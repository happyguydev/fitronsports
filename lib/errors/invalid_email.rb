module Errors
  class InvalidEmail < Errors::Domain
    def initialize(_options = {})
      super(
        code: 'InvalidEmail',
        status: 422,
        message: 'Invalid email address',
        extensions: {
          code: 'InvalidEmail',
          status: 422
        }
      )
    end
  end
end
