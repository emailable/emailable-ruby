module Emailable
  class Client
    ERRORS = {
      400 => BadRequestError,
      401 => UnauthorizedError,
      402 => PaymentRequiredError,
      403 => ForbiddenError,
      404 => NotFoundError,
      429 => TooManyRequestsError,
      500 => InternalServerError,
      503 => ServiceUnavailableError
    }.freeze

    def initialize
      @base_url = 'https://api.emailable.com/v1'
      @connection = create_connection(URI(@base_url))
    end

    def request(method, endpoint, params = {})
      api_key = params.delete(:api_key)
      access_token = params.delete(:access_token)

      uri = URI("#{@base_url}/#{endpoint}")
      headers = {
        'Authorization': "Bearer #{api_key || access_token || Emailable.api_key}",
        'Content-Type': 'application/json'
      }

      begin
        tries ||= 3
        http_response =
          if method == :get
            uri.query = URI.encode_www_form(params) unless params.empty?
            request = Net::HTTP::Get.new(uri, headers)
            @connection.request(request)
          elsif method == :post
            request = Net::HTTP::Post.new(uri, headers)
            request.body = params.to_json
            @connection.request(request)
          end

        response = Response.new(http_response)
      rescue => e
        retry if (tries -= 1) > 0 && should_retry?(e, tries)

        raise e
      end

      status = response.status
      return response if status.between?(200, 299)

      raise ERRORS[status].new(response.body['message'])
    end

    private

    def create_connection(uri)
      connection = Net::HTTP.new(uri.host, uri.port)

      # Time in seconds within which Net::HTTP will try to reuse an already
      # open connection when issuing a new operation. Outside this window, Ruby
      # will transparently close and re-open the connection without trying to
      # reuse it.
      #
      # Ruby's default of 2 seconds is almost certainly too short. Here I've
      # reused Go's default for `DefaultTransport`.
      connection.keep_alive_timeout = 30

      connection.open_timeout = Emailable.open_timeout
      connection.read_timeout = Emailable.read_timeout
      if connection.respond_to?(:write_timeout=)
        connection.write_timeout = Emailable.write_timeout
      end
      connection.use_ssl = uri.scheme == 'https'

      connection
    end

    def should_retry?(error, num_retries)
      return false if num_retries >= Emailable.max_network_retries

      case error
      when Net::OpenTimeout, Net::ReadTimeout
        # Retry on timeout-related problems (either on open or read).
        true
      when EOFError, Errno::ECONNREFUSED, Errno::ECONNRESET,
        Errno::EHOSTUNREACH, Errno::ETIMEDOUT, SocketError
        # Destination refused the connection, the connection was reset, or a
        # variety of other connection failures. This could occur from a single
        # saturated server, so retry in case it's intermittent.
        true
      when Net::HTTPError
        # 409 Conflict
        return true if error.http_status == 409

        # 429 Too Many Requests
        return true if error.http_status == 429

        # 500 Internal Server Error
        return true if error.http_status == 500

        # 503 Service Unavailable
        error.http_status == 503
      else
        false
      end
    end

  end
end
