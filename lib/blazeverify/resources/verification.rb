module BlazeVerify
  class Verification < APIResource
    @@fields =  [:accept_all, :did_you_mean, :disposable, :domain, :duration,
                  :email, :free, :mx_record, :reason, :role, :score,
                  :smtp_provider, :state, :tag, :user, :first_name, :last_name,
                  :full_name, :gender]

    @@fields.each do |f|
      attr_accessor f
    end

    %w(accept_all disposable free role).each do |method|
      define_method("#{method}?") do
        instance_variable_get "@#{method}"
      end
    end

    def [](field)
      if @@fields.include?(field)
        send(field)
      else
        nil
      end
    end
  end
end
