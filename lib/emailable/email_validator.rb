# ActiveRecord validator for validating an email address with Emailable
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
    accept_all = boolean_option_or_raise_error(:accept_all, true)

    timeout = options.fetch(:timeout, 3)
    unless timeout.is_a?(Integer) && timeout > 1
      raise ArgumentError, ":timeout must be an Integer greater than 1"
    end

    return if record.errors[attribute].present?
    return unless value.present?
    return unless record.changes.include?(attribute.to_sym)

    api_options = { timeout: timeout, smtp: smtp }
    api_options[:accept_all] = true unless accept_all
    ev = Emailable.verify(value, api_options)

    result_accessor = "#{attribute}_verification_result"
    if record.respond_to?(result_accessor)
      record.instance_variable_set("@#{result_accessor}", ev)
    end

    error ||= ev.state.to_sym unless states.include?(ev.state.to_sym)
    error ||= :free if ev.free? && !free
    error ||= :role if ev.role? && !role
    error ||= :disposable if ev.disposable? && !disposable
    error ||= :accept_all if ev.accept_all? && !accept_all

    if error
      error_options = options.except(
        :smtp, :states, :free, :role, :disposable, :accept_all, :timeout
      )
      record.errors.add(attribute, error, **error_options)
    end
  rescue Emailable::Error
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
