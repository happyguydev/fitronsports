module Errors
  class InvalidCsrfToken < Domain
    def initialize(_options = {})
      super(
        code: 'InvalidCsrfToken',
        status: 422,
        message: 'Invalid authenticity token. Please refresh the page'
      )
    end
  end
end
