module BlazeVerify
  class APIResource

    protected

    def method_missing(symbol, *args)
      # add ? methods for boolean fields
      instance_variable_get "@#{symbol.to_s.chomp('?').to_sym}"
    end

    def respond_to_missing?(symbol, include_private = false)
      name = symbol.to_s.chomp('?')

      symbol.to_s[-1] == '?' && respond_to?(name) &&
      self.class.boolean_fields.include?(name) || super
    end
  end
end
