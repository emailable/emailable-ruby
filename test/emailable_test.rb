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

  def test_accept_all?
    result = Emailable.verify('accept-all@example.com')
    assert result.accept_all?
  end

  def test_disposable?
    result = Emailable.verify('disposable@example.com')
    assert result.disposable?
  end

  def test_free?
    result = Emailable.verify('free@example.com')
    assert result.free?
  end

  def test_role?
    result = Emailable.verify('role@example.com')
    assert result.role?
  end

  def test_mailbox_full?
    result = Emailable.verify('mailbox-full@example.com')
    assert result.mailbox_full?
  end

  def test_no_reply?
    result = Emailable.verify('no-reply@example.com')
    assert result.no_reply?
  end

  def test_slow_verification
    assert_raises(Emailable::TimeoutError) do
      Emailable.verify('slow@example.com')
    end
  end

end
