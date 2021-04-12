class JanitorsController < ApplicationController
  before_action :authenticate_janitor!
  before_action :set_janitor, only: %i[edit_password, update_password]
  load_and_authorize_resource
  layout 'janitors/dashboard'
  respond_to :html, :json

  def edit
    @facility = Facility.find(params[:facility_id]) if params[:facility_id]
  end

  def update
    @janitor.update(janitor_params)
    redirect_to completion_janitors_path
  end

  def completion; end

  # GET /password/edit
  def edit_password
  end

  # POST /password/update
  def update_password
    if @janitor.update_with_password(pwd_params)
      bypass_sign_in(@janitor)
      redirect_to completion_janitors_path
    else
      render "edit_password"
    end
  end

  private

  def janitor_params
    params.require(:janitor).permit(
      :first_name,
      :last_name,
      :email,
      :phone_number,
      :facility_id
    )
  end

  def set_janitor
    @janitor = current_janitor
  end
  
  def pwd_params
    # NOTE: Using `strong_parameters` gem
    params.require(:janitor).permit(:current_password, :password, :password_confirmation)
  end
end
