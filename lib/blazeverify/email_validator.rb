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
    smtp = boolean_option_or_raise_error(:smtp, true)

    states = options.fetch(:states, %i(deliverable risky unknown))
    allowed_states = %i[deliverable undeliverable risky unknown]
    unless (states - allowed_states).empty?
      raise ArgumentError, ":states must be an array of symbols containing "\
        "any or all of :#{allowed_states.join(', :')}"
    end

    free = boolean_option_or_raise_error(:free, true)
    role = boolean_option_or_raise_error(:role, true)
    disposable = boolean_option_or_raise_error(:disposable, false)
    accept_all = boolean_option_or_raise_error(:accept_all, false)

    timeout = options.fetch(:timeout, 3)
    unless timeout.is_a?(Integer) && timeout > 1
      raise ArgumentError, ":timeout must be an Integer greater than 1"
    end

    return if record.errors[attribute].present?
    return unless value.present?
    return unless record.changes[attribute].present?

    ev = BlazeVerify.verify(value, timeout: timeout, smtp: smtp)

    result_accessor = "#{attribute}_verification_result"
    if record.respond_to?(result_accessor)
      record.instance_variable_set("@#{result_accessor}", ev)
    end

    # if response is taking too long
    return unless ev.respond_to?(:state)

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

  private

  def boolean_option_or_raise_error(name, default)
    option = options.fetch(name, default)
    unless [true, false].include?(option)
      raise ArgumentError, ":#{name} must by a Boolean"
    end

    option
  end

end
