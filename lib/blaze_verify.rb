require 'faraday'
require 'faraday_middleware'
require 'blaze_verify/version'
require 'blaze_verify/client'
require 'blaze_verify/batch'
require 'blaze_verify/resources/api_resource'
require 'blaze_verify/resources/account'
require 'blaze_verify/resources/batch_status'
require 'blaze_verify/resources/verification'

module BlazeVerify
  @max_network_retries = 1

  class << self
    attr_accessor :api_key, :max_network_retries
  end

  module_function

  def verify(email, smtp: nil, accept_all: nil, timeout: nil)
    opts = {
      email: email, smtp: smtp, accept_all: accept_all, timeout: timeout
    }

    client = BlazeVerify::Client.new
    response = client.request(:get, 'verify', opts)

    if response.status == 249
      response.body
    else
      Verification.new(response.body)
    end
  end

  def account
    client = BlazeVerify::Client.new
    response = client.request(:get, 'account')
    Account.new(response.body)
  end
end
