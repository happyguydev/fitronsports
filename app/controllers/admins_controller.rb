class AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin, only: %i[edit destroy update]
  before_action :clear_flash
  layout 'admins/dashboard'
  respond_to :html, :json

  def index
    @admins = Admin.all
  end

  def create 
    @admin = Admin.create(admin_params)
    if @admin.save
      redirect_to admins_path, notice: "#{t("admin.manage_admin.flash.created")}"
    else
      flash.now[:error] = "#{t("admin.manage_admin.flash.errors.created")} #{@admin.errors.full_messages}"
      render 'new'
    end
    
  end

  def destroy
    @admin.deactivate unless @admin == current_admin
    redirect_to admins_path, notice: "#{t("admin.manage_admin.flash.destroyed")}"
  end

  def edit
  end

  def new
    @admin = Admin.new
  end

  def update
    @admin.update(admin_params)
    redirect_to admins_path, notice: "#{t("admin.manage_admin.flash.updated")}"
  end

  private

  def set_admin
    @admin = Admin.find params[:id]
  end

  def admin_params
    params.require(:admin).permit(
      :first_name,
      :last_name,
      :email,
      :password
    )
  end
  
  def clear_flash 
    flash.discard 
  end
end
