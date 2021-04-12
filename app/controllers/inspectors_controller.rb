class InspectorsController < ApplicationController
  before_action :authenticate_inspector!
  before_action :set_inspector, only: %i[edit_password, update_password]
  load_and_authorize_resource
  layout 'inspectors/dashboard'
  respond_to :html, :json

  def edit
    @facility = Facility.find(params[:facility_id]) if params[:facility_id]
  end

  def update
    @inspector.update(inspector_params)
    redirect_to completion_inspectors_path
  end

  def completion; end

  # GET /password/edit
  def edit_password
  end

  # POST /password/update
  def update_password
    if @inspector.update_with_password(pwd_params)
      bypass_sign_in(@inspector)
      redirect_to completion_inspectors_path
    else
      render "edit_password"
    end
  end

  private

  def inspector_params
    params.require(:inspector).permit(
      :first_name,
      :last_name,
      :email,
      :phone_number,
      :facility_id
    )
  end

  def set_inspector
    @inspector = current_inspector
  end
  
  def pwd_params
    # NOTE: Using `strong_parameters` gem
    params.require(:inspector).permit(:current_password, :password, :password_confirmation)
  end
end
