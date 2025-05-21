require 'test_helper'

class EmailValidatorTest < Minitest::Test

  def setup
    Emailable.api_key = 'test_7aff7fc0142c65f86a00'
  end

  def test_valid
    valid_user = user_class.new(email: 'deliverable@example.com')

    assert valid_user.valid?
    assert valid_user.errors.empty?
  end

  def test_invalid
    invalid_user = user_class.new(email: 'undeliverable@example.com')

    refute invalid_user.valid?
    assert invalid_user.errors[:email].present?
  end

  def test_verification_result
    invalid_user = user_class.new(email: 'undeliverable@example.com')
    invalid_user.valid?

    refute_nil invalid_user.email_verification_result
    assert_equal 'undeliverable', invalid_user.email_verification_result.state
  end

  def test_boolean_options_with_invalid_value
    %i[smtp free role disposable accept_all].each do |option|
      invalid_options = user_class(option => 'string').new

      assert_raises(ArgumentError) { invalid_options.valid? }
    end
  end

  def test_states_option_with_invalid_value
    invalid_options = user_class(states: %i[invalid_state]).new

    assert_raises(ArgumentError) { invalid_options.valid? }
  end

  def test_timeout_option_with_invalid_value
    invalid_options1 = user_class(timeout: 'string').new
    invalid_options2 = user_class(timeout: 1).new

    assert_raises(ArgumentError) { invalid_options1.valid? }
    assert_raises(ArgumentError) { invalid_options2.valid? }
  end

  def test_custom_option
    message = 'invalid message'
    valid_options = user_class(message: message, reportable: true).new(
      email: 'undeliverable@example.com'
    )

    refute valid_options.valid?
    assert valid_options.errors[:email].present?
    assert_equal message, valid_options.errors[:email].first
    assert valid_options.errors.where(:email, reportable: true).present?
  end

  private

  def user_class(
    smtp: true, states: %i[deliverable risky unknown], free: true, role: true,
    accept_all: true, disposable: true, timeout: 3, **options
  )
    Class.new do
      include ActiveModel::Model
      attr_accessor :email, :email_verification_result

      validates :email, presence: true, email: {
        smtp: smtp, states: states,
        free: free, role: role, disposable: disposable, accept_all: accept_all,
        timeout: timeout
      }.merge(options)

      def self.name
        'TestClass'
      end

      # stub changes to always be true
      def changes
        { email: true }
      end
    end
  end

end
