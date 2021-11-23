module Emailable
  class APIResource

    def initialize(attributes = {})
      attributes.each do |attr, value|
        instance_variable_set("@#{attr}", value)
      end
    end

    def to_h
      instance_variables.map do |e|
        [e.to_s.delete('@').to_sym, instance_variable_get(e)]
      end.to_h
    end

    alias_method :to_hash, :to_h

    def to_json
      JSON.generate(to_h)
    end

    def inspect
      "#<#{self.class}:0x#{(object_id << 1).to_s(16)}> JSON: " +
        JSON.pretty_generate(to_h)
    end

  end
end
