module Emailable
  class Account < APIResource
    attr_accessor :owner_email, :available_credits
  end
end
