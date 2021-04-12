module Janitors
  class AfterSignupController < ApplicationController
    include Wicked::Wizard

    layout 'janitors/registrations'
    before_action :authenticate_janitor!, :set_janitor
    steps :information

    def show
      render_wizard
    end

    def update
      case step
      when :information
        @janitor.update(janitor_params)
        @janitor.send_confirmation_instructions
      end

      sign_in @janitor, bypass: true
      render_wizard @janitor
    end

    private

    def janitor_params
      params.require(:janitor).permit(:first_name, :last_name, :name, :facility_id)
    end

    def set_janitor
      @janitor = current_janitor
    end
  end
end
