class ApplicationController < ActionController::Base
  include Errorable

  before_action :check_source_as_pwa
  #http_basic_authenticate_with name: ENV['HTTP_BASIC_USER'],
  #                              password: ENV['HTTP_BASIC_PASSWORD'],
  #                              if: -> { Rails.env.staging? }

  devise_group :account, contains: %i[janitor inspector]

  alias current_user current_account

  def after_sign_in_path_for(resource)
    return janitors_root_path if resource == :janitor
    return inspectors_root_path if resource == :inspector
    return admins_root_path if resource == :admin
    super
  end
  
  def after_sign_out_path_for(resource)
    return new_janitor_session_path if resource == :janitor
    return new_inspector_session_path if resource == :inspector
    return new_admin_session_path if resource == :admin
    super
  end

  def check_source_as_pwa
    if params[:source] == "pwa"
      session[:src_pwa] = true
    end
  end
end
