module Errors
  class InvalidPassword < Errors::Domain
    def initialize(_options = {})
      super(
        code: 'InvalidPassword',
        status: 422,
        message: 'Invalid password',
        extensions: {
          code: 'InvalidPassword',
          status: 422
        }
      )
    end
  end
end
