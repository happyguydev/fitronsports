module Inspectors
  class AfterSignupController < ApplicationController
    include Wicked::Wizard

    layout 'inspectors/registrations'
    before_action :authenticate_inspector!, :set_inspector
    steps :information

    def show
      render_wizard
    end

    def update
      case step
      when :information
        @inspector.update(inspector_params)
        @inspector.send_confirmation_instructions
      end

      sign_in @inspector, bypass: true
      render_wizard @inspector
    end

    private

    def inspector_params
      params.require(:inspector).permit(:first_name, :last_name, :name, :facility_id)
    end

    def set_inspector
      @inspector = current_inspector
    end
  end
end
