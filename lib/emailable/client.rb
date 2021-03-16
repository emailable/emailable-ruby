module Emailable
  class Client

    def initialize
      @client = Faraday.new('https://api.emailable.com/v1') do |f|
        f.request :url_encoded
        f.response :json, content_type: /\bjson$/
        f.adapter :net_http_persistent
      end
    end

    def request(method, endpoint, opts = {})
      begin
        tries ||= 0

        @client.params[:api_key] = Emailable.api_key

        response =
          if method == :get
            @client.get(endpoint, opts)
          elsif method == :post
            @client.post(endpoint, opts)
          end
      rescue => e
        retry if self.class.should_retry?(e, tries)

        raise e
      end

      status = response.status
      return response if status.between?(200, 299)

      error_attributes = {
        message: response.body['message'],
        code: status
      }
      error_map = {
        '400' => BadRequestError,
        '401' => UnauthorizedError,
        '402' => PaymentRequiredError,
        '403' => ForbiddenError,
        '404' => NotFoundError,
        '429' => TooManyRequestsError,
        '500' => InternalServerError,
        '503' => ServiceUnavailableError
      }

      raise error_map[status.to_s].new(error_attributes)
    end

    def self.should_retry?(error, num_retries)
      return false if num_retries >= Emailable.max_network_retries

      # Retry on timeout-related problems (either on open or read).
      return true if error.is_a?(Faraday::TimeoutError)

      # Destination refused the connection, the connection was reset, or a
      # variety of other connection failures. This could occur from a single
      # saturated server, so retry in case it's intermittent.
      return true if error.is_a?(Faraday::ConnectionFailed)

      if error.is_a?(Faraday::ClientError) && error.response
        # 409 conflict
        return true if error.response[:status] == 409
      end

      false
    end
  end
end
