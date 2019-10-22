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
    refute_nil @result.duration
  end

  def test_verification_state
    assert %w(deliverable undeliverable risky unknown).include?(@result.state)
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

  def test_verification_tag
    result = BlazeVerify.verify('jarrett+marketing@blazeverify.com')
    assert result.tag == 'marketing'
  end

  def test_account
    account = BlazeVerify.account

    refute_nil account.owner_email
    refute_nil account.available_credits
  end

  def test_name_and_gender
    result = BlazeVerify.verify('johndoe@blazeverify.com')
    if %w(deliverable risky unknown).include?(result.state)
      assert result.first_name, 'John'
      assert result.last_name, 'Doe'
      assert result.first_name, 'John Doe'
      assert result.gender, 'male'
    else
      assert_nil result.first_name
      assert_nil result.last_name
      assert_nil result.full_name
      assert_nil result.gender
    end
  end

end
