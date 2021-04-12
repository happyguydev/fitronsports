module ActiveModel
  class Errors
    def as_json(*_args)
      ::Errors::Validation.new(
        errors: self
      ).to_h
    end
  end
end
