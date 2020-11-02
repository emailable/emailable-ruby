module BlazeVerify
  class Batch
    attr_accessor :id

    def initialize(id_or_emails, callback: nil)
      @id = nil
      @status = nil

      if id_or_emails.is_a?(Array)
        @emails = id_or_emails
        @callback = callback
      elsif id_or_emails.is_a?(String)
        @id = id_or_emails
      else
        raise ArgumentError, 'expected an array of emails or batch id'
      end

      @client = BlazeVerify::Client.new
    end

    def verify
      return @id unless @id.nil?

      opts = { emails: @emails.join(','), url: @callback }
      response = @client.request(:post, 'batch', opts)

      @id = response.body['id']
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
      !status.complete?
    end

    def inspect
      ivars = instance_variables.map do |e|
        [e.to_s.delete('@'), instance_variable_get(e)]
      end.to_h
      "#<#{self.class}:0x#{(object_id << 1).to_s(16)}> JSON: " +
        JSON.pretty_generate(ivars)
    end

  end
end
