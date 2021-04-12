module Admins
  class DashboardController < ApplicationController
    layout 'admins/dashboard'
    before_action :authenticate_admin!
    before_action :set_admin

    def home
    end

    def layout
    end

    private

    def set_admin
      @admin = current_admin
    end
  end
end