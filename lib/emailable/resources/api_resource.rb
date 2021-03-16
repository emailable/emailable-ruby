module Emailable
  class APIResource

    def initialize(attributes = {})
      attributes.each do |attr, value|
        instance_variable_set("@#{attr}", value)
      end
    end

    def inspect
      ivars = instance_variables.map do |e|
        [e.to_s.delete('@'), instance_variable_get(e)]
      end.to_h
      fmtted_email = @email ? " #{@email}" : ''
      "#<#{self.class}:0x#{(object_id << 1).to_s(16)}#{fmtted_email}> JSON: " +
        JSON.pretty_generate(ivars)
    end

  end
end
