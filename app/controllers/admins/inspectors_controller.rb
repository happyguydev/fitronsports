module Admins
  class InspectorsController < ApplicationController
    include FacilitiesHelper
    layout 'admins/dashboard'
    before_action :set_inspector, only: %i[destroy edit show update]
    before_action :clear_flash

    def index
      @inspectors = Inspector.active
    end

    def new
      @inspector = Inspector.new
    end

    def create
      @inspector = Inspector.new(inspector_params)
      @inspector.terms_of_service = true
      respond_to do |format|
        if @inspector.save
          format.html { redirect_to admins_inspectors_path, notice: t("admin.inspectors.flash.created") }
        else
          flash.now[:error] = "#{t("admin.inspectors.flash.errors.created")} #{@inspector.errors.full_messages}"
          format.html { render 'admins/inspectors/new' }
        end
      end
    end

    def edit; end

    def update
      respond_to do |format|
        if @inspector.update(inspector_params)
          format.html { redirect_to admins_inspectors_path, notice: t("admin.inspectors.flash.updated") }
        else
          flash.now[:error] = "#{t("admin.inspectors.flash.errors.updated")} #{@inspector.errors.full_messages}"
          format.html { render "admins/inspectors/edit" }
        end
      end
    end

    def destroy
      @inspector.deactivate
      flash.now[:success] = t("admin.inspectors.flash.destroyed")
      redirect_to admins_inspectors_path
    end

    private

    def set_inspector
      @inspector = Inspector.find(params[:id])
    end

    def inspector_params
      params.require(:inspector).permit(:first_name, :last_name, :email, :phone_number, :password)
    end

    def clear_flash 
      flash.discard 
    end
  end
end
