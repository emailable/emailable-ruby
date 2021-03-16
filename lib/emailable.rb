require 'faraday'
require 'faraday_middleware'
require 'emailable/version'
require 'emailable/client'
require 'emailable/batch'
require 'emailable/resources/api_resource'
require 'emailable/resources/account'
require 'emailable/resources/batch_status'
require 'emailable/resources/verification'
if defined?(ActiveModel)
  require 'emailable/email_validator'
  I18n.load_path += Dir.glob(File.expand_path('../../config/locales/**/*', __FILE__))
end

module Emailable
  @max_network_retries = 1

  class << self
    attr_accessor :api_key, :max_network_retries
  end

  module_function

  def verify(email, smtp: nil, accept_all: nil, timeout: nil)
    opts = {
      email: email, smtp: smtp, accept_all: accept_all, timeout: timeout
    }

    client = Emailable::Client.new
    response = client.request(:get, 'verify', opts)

    if response.status == 249
      raise Emailable::TimeoutError.new(
        code: response.status, message: response.body
      )
    else
      Verification.new(response.body)
    end
  end

  def account
    client = Emailable::Client.new
    response = client.request(:get, 'account')
    Account.new(response.body)
  end


  class Error < StandardError
    attr_accessor :code, :message

    def initialize(code: nil, message: nil)
      @code = code
      @message = message
    end
  end
  class BadRequestError < Error; end
  class UnauthorizedError < Error; end
  class PaymentRequiredError < Error; end
  class ForbiddenError < Error; end
  class NotFoundError < Error; end
  class TooManyRequestsError < Error; end
  class InternalServerError < Error; end
  class ServiceUnavailableError < Error; end
  class TimeoutError < Error; end
end
