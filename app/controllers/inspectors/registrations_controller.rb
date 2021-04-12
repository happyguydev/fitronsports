module Inspectors
  class RegistrationsController < Devise::RegistrationsController
    respond_to :html, :json
    layout 'inspectors/registrations'

    before_action :set_facilities, only: %i[new]
    before_action :configure_sign_up_params, only: %i[create]

    def new
      super do
        @facility = Facility.find(params[:facility_id]) if params[:facility_id]
      end
    end

    def create
      super
    end

    private

    def set_facilities
      @facilities = Facility.first(20)
    end

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[name phone_number facility_id terms_of_service])
    end
  end
end