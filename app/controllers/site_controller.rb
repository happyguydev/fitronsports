class SiteController < ApplicationController
  def home
    if current_admin
      redirect_to controller: 'admins/requests', action: :index
    else
      redirect_to controller: 'janitors/dashboard', action: :home
    end
  end
end
