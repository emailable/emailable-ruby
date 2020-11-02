require 'faraday'
require 'faraday_middleware'
require 'blazeverify/version'
require 'blazeverify/client'
require 'blazeverify/batch'
require 'blazeverify/resources/api_resource'
require 'blazeverify/resources/account'
require 'blazeverify/resources/batch_status'
require 'blazeverify/resources/verification'

module BlazeVerify
  @max_network_retries = 1

  class << self
    attr_accessor :api_key, :max_network_retries
  end

  module_function

  def verify(email, timeout: 10, smtp: nil, accept_all: nil)
    opts = {
      email: email, smtp: smtp, accept_all: accept_all
    }

    client = BlazeVerify::Client.new

    Timeout.timeout(timeout) do
      response = client.request(:get, 'verify', opts)
      Verification.new(response.body)
    end
  end

  def account
    client = BlazeVerify::Client.new
    response = client.request(:get, 'account')
    Account.new(response.body)
  end
end
