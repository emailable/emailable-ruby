module BlazeVerify
  class Batch
    attr_accessor :id

    def initialize(id_or_emails, callback: nil)
      if id_or_emails.is_a?(Array)
        @emails = id_or_emails
        @callback = callback
        @verifying = false
      else
        @id = id_or_emails
        @verifying = true
      end

      @client = BlazeVerify::Client.new
    end

    def verify
      return nil if @verifying

      opts = { emails: @emails.join(','), url: @callback }
      response = @client.request(:post, 'batch', opts)

      @id = response.body['id']
      @id
    end

    def status
      return nil unless @id
      return @status if @status

      response = @client.request(:get, 'batch', { id: @id })
      bs = BatchStatus.new(response.body)
      @status = bs if bs.complete?

      bs
    end

    def complete?
      !status.emails.nil?
    end
  end
end
