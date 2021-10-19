module Emailable
  class Batch
    attr_accessor :id

    def initialize(id_or_emails, callback: nil)
      if id_or_emails.is_a?(Array)
        @id = nil
        @emails = id_or_emails
        @callback = callback
      elsif id_or_emails.is_a?(String)
        @id = id_or_emails
        @emails = nil
        @callback = nil
      else
        raise ArgumentError, 'expected an array of emails or batch id'
      end

      @client = Emailable::Client.new
      @status = nil
    end

    def verify(simulate: nil)
      return @id unless @id.nil?

      opts = { emails: @emails.join(','), url: @callback, simulate: simulate }
      response = @client.request(:post, 'batch', opts)

      @id = response.body['id']
    end

    def status(simulate: nil)
      return nil unless @id
      return @status if @status

      response = @client.request(:get, 'batch', { id: @id, simulate: simulate })
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
