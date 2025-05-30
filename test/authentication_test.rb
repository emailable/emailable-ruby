require 'test_helper'

class AuthenticationTest < Minitest::Test

  def setup
    @api_key = 'test_7aff7fc0142c65f86a00'
    @email = 'jarrett@emailable.com'
    @emails = ['jarrett@emailable.com', 'support@emailable.com']
  end

  def test_global_api_key_authentication
    Emailable.api_key = @api_key

    refute_nil Emailable.verify(@email).domain
    refute_nil Emailable.account.owner_email
    refute_nil bid = Emailable::Batch.new(@emails).verify
    refute_nil Emailable::Batch.new(bid).status.id
  end

  def test_request_time_api_key_authentication
    refute_nil Emailable.verify(@email, api_key: @api_key).domain
    refute_nil Emailable.account(api_key: @api_key).owner_email
    refute_nil bid = Emailable::Batch.new(@emails).verify(api_key: @api_key)
    refute_nil Emailable::Batch.new(bid).status(api_key: @api_key).id
  end

end
