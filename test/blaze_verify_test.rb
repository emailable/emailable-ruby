require 'test_helper'

class BlazeVerifyTest < Minitest::Test

  def setup
    BlazeVerify.api_key = 'test_7aff7fc0142c65f86a00'
    @result ||= BlazeVerify.verify('jarrett@blazeverify.com')
    sleep(0.25)
  end

  def test_verification
    refute_nil @result.domain
    refute_nil @result.email
    refute_nil @result.reason
    refute_nil @result.score
    refute_nil @result.state
    refute_nil @result.user
  end

  def test_verification_state
    assert %w(deliverable undeliverable risky unknown).include?(@result.state)
  end

  def test_verification_free
    result = BlazeVerify.verify('jarrett@gmail.com')
    assert result.free?
    refute @result.free?
  end

  def test_verification_role
    result = BlazeVerify.verify('support@blazeverify.com')
    assert result.role?
    refute @result.role?
  end

  def test_verification_did_you_mean
    result = BlazeVerify.verify('jarrett@gmali.com')
    assert result.did_you_mean, 'jarrett@gmail.com'
    assert_nil @result.did_you_mean
  end

  def test_verification_score
    assert @result.score.is_a?(Integer)
  end

  def test_verification_tag
    result = BlazeVerify.verify('jarrett+marketing@blazeverify.com')
    assert result.tag == 'marketing'
  end

  def test_account
    BlazeVerify.api_key = 'test_7aff7fc0142c65f86a00'
    account = BlazeVerify.account

    refute_nil account.owner_email
    refute_nil account.available_credits
  end

end
