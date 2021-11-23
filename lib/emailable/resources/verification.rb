module Emailable
  class Verification < APIResource
    attr_accessor :accept_all, :did_you_mean, :disposable, :domain, :duration,
                  :email, :free, :mx_record, :reason, :role, :score,
                  :smtp_provider, :state, :tag, :user, :first_name, :last_name,
                  :full_name, :gender

    %w(accept_all disposable free role).each do |method|
      define_method("#{method}?") do
        instance_variable_get "@#{method}"
      end
    end

    def inspect
      "#<#{self.class}:0x#{(object_id << 1).to_s(16)}#{@email}> JSON: " +
        JSON.pretty_generate(to_h)
    end

  end
end
