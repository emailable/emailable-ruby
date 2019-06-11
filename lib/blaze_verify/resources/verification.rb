module BlazeVerify
  class Verification < APIResource
    attr_accessor :accept_all, :did_you_mean, :disposable, :domain, :email,
                  :free, :reason, :role, :score, :state, :tag, :user

    def self.boolean_fields
      %w(accept_all disposable free role)
    end

    def initialize(attributes = {})
      attributes.each do |attr, value|
        send("#{attr}=", value)
      end
    end
  end
end
