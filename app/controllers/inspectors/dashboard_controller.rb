module Inspectors
  class DashboardController < ApplicationController
    layout 'inspectors/dashboard'
    before_action :authenticate_inspector!
    before_action :set_inspector

    # GET /dashboard/home
    # GET /dashboard
    def home
      @reports = Report.accessible_by(current_ability)
    end

    def profile; end

    # GET /dashboard/help
    def help; end

    # GET /dashboard/terms
    def terms; end

    # GET /dashboard/privacy
    def privacy; end

    private

    def set_inspector
      @inspector = current_inspector
    end
  end
end