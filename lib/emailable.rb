require 'net/http'
require 'json'

require 'emailable/version'
require 'emailable/errors'
require 'emailable/client'
require 'emailable/response'
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
  @open_timeout = 30
  @read_timeout = 60
  @write_timeout = 30

  class << self
    attr_accessor :api_key, :max_network_retries, :open_timeout, :read_timeout,
      :write_timeout
  end

  module_function

  def verify(email, parameters = {})
    parameters[:email] = email

    client = Emailable::Client.new
    response = client.request(:post, 'verify', parameters)

    if response.status == 249
      raise Emailable::TimeoutError.new(response.body)
    else
      Verification.new(response.body)
    end
  end

  def account(parameters = {})
    client = Emailable::Client.new
    response = client.request(:get, 'account', parameters)
    Account.new(response.body)
  end

end
