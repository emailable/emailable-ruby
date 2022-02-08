module Emailable
  class Batch
    attr_accessor :id

    def initialize(id_or_emails)
      if id_or_emails.is_a?(Array)
        @id = nil
        @emails = id_or_emails
      elsif id_or_emails.is_a?(String)
        @id = id_or_emails
        @emails = nil
      else
        raise ArgumentError, 'expected an array of emails or batch id'
      end

      @client = Emailable::Client.new
      @status = nil
    end

    def verify(parameters = {})
      return @id unless @id.nil?

      parameters[:emails] = @emails.join(',')
      response = @client.request(:post, 'batch', parameters)

      @id = response.body['id']
    end

    def status(parameters = {})
      return nil unless @id
      return @status if @status

      parameters[:id] = @id
      response = @client.request(:get, 'batch', parameters)
      bs = BatchStatus.new(response.body)
      @status = bs if bs.complete?

      bs
    end

    def complete?
      status.complete?
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
