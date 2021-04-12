# An rails concern to handle parsing and display API errors
module Errorable
  extend ActiveSupport::Concern

  # Map Rails Errors to our own custom Error classes
  ERROR_MAPPINGS = {
    'ActionController::InvalidAuthenticityToken': 'Errors::InvalidCsrfToken',
    'ActiveRecord::RecordInvalid': 'Errors::Validation'
  }.stringify_keys.freeze

  # Helper methods to make rendering a certain type of error simpler
  # e.g. render_validation_error errors: @model.errors
  RENDER_ERRORS = {
    validation: 'Errors::Validation',
    invalid_credentials: 'Errors::InvalidCredentials',
    invalid_email: 'Errors::InvalidEmail',
    invalid_password: 'Errors::InvalidPassword'
  }.freeze

  included do
    rescue_from StandardError, with: ->(e) { json_request? ? handle_error(e) : raise(e) }
  end

  def json_request?
    request.format.json?
  end

  # Define the render_error methods for each of our 'RENDER_ERRORS'
  RENDER_ERRORS.each do |key, _|
    define_method "render_#{key}_error" do |options = {}|
      render_error key.to_sym, options
    end
  end

  private

  # Implement the render_error function
  def render_error(error_type = :domain, options = {})
    class_name = error_type.to_sym

    class_name = RENDER_ERRORS[class_name] if RENDER_ERRORS.keys.include?(class_name)

    # Safely initalize the error class or default to a DomainError
    error = class_name.safe_constantize&.new(options) || Errors::Domain.new(options)

    # Render the error as a JSON object
    render_json_error error
  end

  # A generic error handler
  def handle_error(error)
    return unless json_request?

    mapped_error = map_error(error)

    # Show the raw error in development opposed to a domain error
    if Rails.env.development? && mapped_error.nil?
      render_json_error error
    else
      mapped_error ||= Errors::Domain.new
      render_json_error mapped_error
    end
  end

  # Maps an error object to our domain errors
  def map_error(error)
    class_name = error.class.name
    application_error = class_name.start_with?('Errors::')

    if application_error || ERROR_MAPPINGS.values.include?(class_name)
      error
    else
      ERROR_MAPPINGS[class_name]&.safe_constantize&.new message: error.message
    end
  end

  # Returns a JSON object of an error
  def render_json_error(error)
    # Get the serialized error object
    serialized_error = if error.respond_to? :serializable_hash
                         error.serializable_hash
                       else
                         Errors::Domain.new(
                           code: error.class.name,
                           message: error.message,
                           status: 500
                         ).serializable_hash
                       end

    # Get the error status
    status = error.try(:status) || 500

    # Join the backtrace if development
    serialized_error = serialized_error.merge backtrace: error.try(:backtrace) if Rails.env.development?

    # Render the error
    render json: { error: serialized_error }, status: status
  end
end
