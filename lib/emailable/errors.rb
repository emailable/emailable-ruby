module Emailable
  class Error < StandardError; end
  class BadRequestError < Error; end
  class UnauthorizedError < Error; end
  class PaymentRequiredError < Error; end
  class ForbiddenError < Error; end
  class NotFoundError < Error; end
  class TooManyRequestsError < Error; end
  class InternalServerError < Error; end
  class ServiceUnavailableError < Error; end
  class TimeoutError < Error; end
end
