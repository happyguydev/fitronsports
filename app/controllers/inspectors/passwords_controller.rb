# frozen_string_literal: true

class Inspectors::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  def new
    super
  end

  # POST /resource/password
  def create
    resource = find_resource password_params[:email]
    # return invalid_reset_attempt if resource.blank?

    self.resource = resource_class.send_reset_password_instructions(resource_params) if !resource.blank?
=begin
    if successfully_sent?(resource)
      flash[:notice] = "sent password"
    else
      respond_with(resource)
    end
=end
    flash[:success] = t("devise.passwords.reset_password_email_sent")
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    resource = resource_class.find_by_reset_password_token(params[:reset_password_token])
    return redirect_to new_inspector_session_path, notice: 'invalid token' if resource.blank?
    super
  end

  def update
    resource = resource_class.find_by_reset_password_token(new_password_params[:reset_password_token])
    invalid_reset_attempt if resource.blank?

    if resource.reset_password(new_password_params[:password], new_password_params[:password_confirmation])
      puts "\n\n\ninspectors password controller"
      puts "\n#{resource_class.name}   :  #{resource_name}"
      bypass_sign_in(resource)
      redirect_to inspectors_root_path, notice: t('devise.passwords.changed_successfully')
    else
      respond_to do |format|
        format.json { render_invalid_password_error }
      end
    end
  end

  private

  def find_resource(email)
    resource_class.find_for_database_authentication email: email
  end

  def invalid_reset_attempt
    respond_to do |format|
      format.json { render_invalid_email_error }
    end
  end

  def password_params
    params.require(resource_name).permit(:email)
  end

  def new_password_params
    params.require(resource_name).permit(
      :reset_password_token,
      :password,
      :password_confirmation
    )
  end
end
