module BlazeVerify
  class APIResource

    def initialize(attributes = {})
      attributes.each do |attr, value|
        instance_variable_set("@#{attr}", value)
      end
    end

  end
end
