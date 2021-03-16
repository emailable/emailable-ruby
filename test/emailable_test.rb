require 'test_helper'

class EmailableTest < Minitest::Test

  def setup
    Emailable.api_key = 'test_7aff7fc0142c65f86a00'
    @result ||= Emailable.verify('jarrett@emailable.com')
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
    result = Emailable.verify('support@emailable.com')
    assert result.role?
    refute @result.role?
  end

  def test_verification_did_you_mean
    result1 = Emailable.verify('jarrett@gmali.com')
    result2 = Emailable.verify('jarrett@gmail.com')
    assert result1.did_you_mean, 'jarrett@gmail.com'
    assert_nil result2.did_you_mean
  end

  def test_verification_tag
    result = Emailable.verify('jarrett+marketing@emailable.com')
    assert result.tag == 'marketing'
  end

  def test_account
    account = Emailable.account

    refute_nil account.owner_email
    refute_nil account.available_credits
  end

  def test_name_and_gender
    result = Emailable.verify('johndoe@emailable.com')
    if %w(deliverable risky unknown).include?(result.state)
      assert result.first_name, 'John'
      assert result.last_name, 'Doe'
      assert result.full_name, 'John Doe'
      assert result.gender, 'male'
    else
      assert_nil result.first_name
      assert_nil result.last_name
      assert_nil result.full_name
      assert_nil result.gender
    end
  end

  def test_slow_verification
    assert_raises(Emailable::TimeoutError) do
      Emailable.verify('slow@example.com')
    end
  end

end
