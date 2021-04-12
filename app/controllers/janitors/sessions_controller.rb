module Janitors
  class SessionsController < Devise::SessionsController
    respond_to :html, :json

    def create
      resource = find_resource session_params[:email]
      return invalid_sign_in_attempt if resource.blank?

      if resource.valid_password? session_params[:password]
        sign_in resource_name, resource

        respond_to do |format|
          format.html { redirect_to janitors_root_path }
          format.json { render json: current_account, root: janitors_root_path }
        end
      else
        invalid_sign_in_attempt
      end
    end

    private

    def find_resource(email)
      resource_class.find_for_database_authentication email: email
    end

    def invalid_sign_in_attempt
      warden.custom_failure!

      respond_to do |format|
        format.json { render_invalid_credentials_error }
        format.html do 
          set_flash_message :alert, :invalid
          render 'new'
        end
      end
    end

    def session_params
      params.require(resource_name).permit(:email, :password, :remember_me)
    end
  end
end
