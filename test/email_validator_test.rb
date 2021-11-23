require 'active_model'
require 'test_helper'

class EmailValidatorTest < Minitest::Test

  def user_class(
    smtp: true, states: %i[deliverable risky unknown], free: true, role: true,
    accept_all: true, disposable: true, timeout: 3
  )
    Class.new do
      include ActiveModel::Model
      attr_accessor :email, :email_verification_result

      validates :email, presence: true, email: {
        smtp: smtp, states: states,
        free: free, role: role, disposable: disposable, accept_all: accept_all,
        timeout: timeout
      }

      def self.name
        'TestClass'
      end

      # stub changes to always be true
      def changes
        { email: true }
      end
    end
  end

  def setup
    Emailable.api_key = 'test_7aff7fc0142c65f86a00'
    sleep(0.25)
  end

  def test_valid
    @user = user_class.new(email: 'deliverable@example.com')

    assert @user.valid?
    assert @user.errors.empty?
  end

  def test_invalid
    @user = user_class.new(email: 'undeliverable@example.com')

    assert !@user.valid?
    assert @user.errors[:email].present?
  end

  def test_verification_result
    @user = user_class.new(email: 'undeliverable@example.com')
    @user.valid?

    refute_nil @user.email_verification_result
    assert @user.email_verification_result.state, :undeliverable
  end

  def test_boolean_options
    %i[smtp free role disposable accept_all].each do |option|
      invalid_user = user_class(option => 'string').new
      valid_user = user_class.new

      assert !valid_user.valid?
      assert_raises(ArgumentError) { invalid_user.valid? }
    end
  end

  def test_states_option
    invalid_user = user_class(states: %i[invalid_state]).new
    valid_user = user_class.new

    assert !valid_user.valid?
    assert_raises(ArgumentError) { invalid_user.valid? }
  end

  def test_timeout_option
    invalid_user1 = user_class(timeout: 'string').new
    invalid_user2 = user_class(timeout: 1).new
    valid_user = user_class.new

    assert !valid_user.valid?
    assert_raises(ArgumentError) { invalid_user1.valid? }
    assert_raises(ArgumentError) { invalid_user2.valid? }
  end

end
