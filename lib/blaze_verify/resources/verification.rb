module BlazeVerify
  class Verification < APIResource
    attr_accessor :accept_all, :did_you_mean, :disposable, :domain, :email,
                  :free, :reason, :role, :score, :state, :tag, :user

    %w(accept_all disposable free role).each do |method|
      define_method("#{method}?") do
        instance_variable_get "@#{method}"
      end
    end
  end
end
