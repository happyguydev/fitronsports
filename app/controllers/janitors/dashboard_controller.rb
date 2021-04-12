module Janitors
  class DashboardController < ApplicationController
    layout 'janitors/dashboard'
    before_action :authenticate_janitor!
    before_action :set_janitor

    # GET /dashboard/home
    # GET /dashboard
    def home
      @requests = Request.accessible_by(current_ability)
    end

    # GET /dashboard/profile
    def profile; end

    # GET /dashboard/help
    def help; end

    # GET /dashboard/terms
    def terms; end

    # GET /dashboard/privacy
    def privacy; end

    private

    def set_janitor
      @janitor = current_janitor
    end
  end
end
