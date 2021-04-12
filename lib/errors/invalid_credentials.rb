module Errors
  class InvalidCredentials < Errors::Domain
    def initialize(_options = {})
      super(
        code: 'InvalidCredentials',
        status: 422,
        message: 'Invalid email or password',
        extensions: {
          code: 'InvalidCredentials',
          status: 422
        }
      )
    end
  end
end
