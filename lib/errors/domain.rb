module Errors
  class Domain < StandardError
    attr_reader :message, :code, :status, :detail

    def initialize(options = {})
      @code = options[:code] || 'DomainError'
      @message = options[:message] || 'We encountered unexpected error, but our developers had been already notified about it'
      @status = options[:status] || 500
      @detail = options[:detail] || {}
      @extensions = options[:extensions] || {}
    end

    def to_h
      {
        status: status,
        code: code,
        message: message,
        detail: detail,
        extensions: @extensions
      }.deep_stringify_keys
    end

    def serializable_hash
      to_h
    end

    delegate :to_s, to: :to_h
  end
end
