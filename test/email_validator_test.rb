require 'test_helper'

class EmailValidatorTest < Minitest::Test

  def user_class
    Class.new do
      include ActiveModel::Model
      attr_accessor :email, :email_verification_result

      validates :email, presence: true, email: {
        smtp: true, states: %i[deliverable risky unknown],
        free: true, role: true, disposable: true, accept_all: true
      }

      # stub changes to always be true
      def changes
        { email: true }
      end
    end
  end

  def setup
    BlazeVerify.api_key = 'test_7aff7fc0142c65f86a00'
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

end
