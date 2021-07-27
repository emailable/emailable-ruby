module Emailable
  class Response

    attr_accessor :status, :body

    def initialize(response)
      @status = response.code.to_i
      @body = JSON.parse(response.body)
    end

  end
end
