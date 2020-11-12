# ActiveRecord validator for validating an email address with Blaze Verify
#
# Usage:
#   validates :email, presence: true, email: {
#     smtp: true, states: %i[deliverable risky unknown],
#     free: true, role: true, disposable: false, accept_all: true,
#     timeout: 3
#   }
#
# Define an attr_accessor to access verification results.
#   attr_accessor :email_verification_result
#
class EmailValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if record.errors[attribute].present?
    return unless value.present?
    return unless record.changes[attribute].present?

    smtp = options.fetch(:smtp, true)
    states = options.fetch(:states, %i(deliverable risky unknown))
    free = options.fetch(:free, true)
    role = options.fetch(:role, true)
    disposable = options.fetch(:disposable, false)
    accept_all = options.fetch(:accept_all, false)
    timeout = options.fetch(:timeout, 3)

    ev = BlazeVerify.verify(value, timeout: timeout, smtp: smtp)

    result_accessor = "#{attribute}_verification_result"
    if record.respond_to?(result_accessor)
      record.instance_variable_set("@#{result_accessor}", ev)
    end

    error ||= ev.state unless states.include?(ev.state.to_sym)
    error ||= :free if ev.free? && !free
    error ||= :role if ev.role? && !role
    error ||= :disposable if ev.disposable? && !disposable
    error ||= :accept_all if ev.accept_all? && !accept_all

    translation = I18n.t(error, :scope => 'blazeverify.validations.email')
    record.errors.add(attribute, translation) if error
  rescue BlazeVerify::Error
    # silence errors
  end

end
