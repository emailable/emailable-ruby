require 'test_helper'

class EmailableTest < Minitest::Test

  def setup
    Emailable.api_key = 'test_7aff7fc0142c65f86a00'
  end

  def test_verification
    result = Emailable.verify('jarrett@emailable.com')
    refute_nil result.domain
    refute_nil result.email
    refute_nil result.reason
    refute_nil result.score
    refute_nil result.state
    refute_nil result.user
    refute_nil result.duration
  end

  def test_verification_state
    result = Emailable.verify('jarrett@emailable.com')
    assert %w(deliverable undeliverable risky unknown).include?(result.state)
  end

  def test_verification_tag
    result = Emailable.verify('jarrett+marketing@emailable.com')
    assert_equal 'marketing', result.tag
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

  def test_accept_all?
    assert Emailable.verify('accept-all@example.com').accept_all?
  end

  def test_disposable?
    assert Emailable.verify('disposable@example.com').disposable?
  end

  def test_free?
    assert Emailable.verify('free@example.com').free?
  end

  def test_role?
    assert Emailable.verify('role@example.com').role?
  end

  def test_mailbox_full?
    assert Emailable.verify('mailbox-full@example.com').mailbox_full?
  end

  def test_no_reply?
    assert Emailable.verify('no-reply@example.com').no_reply?
  end

  def test_slow_verification
    assert_raises(Emailable::TimeoutError) do
      Emailable.verify('slow@example.com')
    end
  end

end
