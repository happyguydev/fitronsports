module Errors
  class Validation < Errors::Domain
    attr_reader :errors

    def initialize(options = {})
      if options.is_a?(Array) || options.is_a?(ActiveModel::Errors)
        @errors = options
        options = {}
      else
        @errors = options[:errors] || []
      end

      @status = 422
      @message = options[:message] || I18n.t('activemodel.validation.failed')
      @code = 'Validation'
      @detail = parsed_errors
    end

    def parsed_errors
      @errors.messages
    end

    def to_h
      super.merge!(
        extensions: {
          messages: @errors.full_messages
        }
      )
    end
  end
end
