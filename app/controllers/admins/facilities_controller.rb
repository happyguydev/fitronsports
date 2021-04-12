module Admins
  class FacilitiesController < ApplicationController
    layout 'admins/dashboard'
    before_action :set_facility, only: %i[show edit update destroy]
    before_action :clear_flash

    def index
        @facilities = Facility.all.active
    end

    def show; end

    def new
      @facility = Facility.new
    end

    def edit; end

    def create
      @facility = Facility.new(facility_params)

      respond_to do |format|
        if @facility.save
          format.html { redirect_to admins_facilities_url, notice: t("admin.facilities.flash.created")  }
          format.json { render :show, status: :created, location: @facility }
        else
          flash.now[:error] = "#{t("admin.facilities.flash.errors.created")}"
          format.html { render 'admins/facilities/new' }
          format.json { render json: @facility.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @facility.update(facility_params)
          format.html { redirect_to admins_facilities_url, notice:  t("admin.facilities.flash.udpated") }
          format.json { render :show, status: :ok, location: @facility }
        else
          flash.now[:error] = "#{t("admin.facilities.flash.errors.updated")}"
          format.html { render :edit }
          format.json { render json: @facility.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @facility.deactivate
      respond_to do |format|
        format.html { redirect_to admins_facilities_url, notice:  t("admin.facilities.flash.destroyed") }
        format.json { head :no_content }
      end
    end

    private

    def set_facility
      @facility = Facility.find(params[:id])
    end

    def facility_params
      params.require(:facility).permit(:name, :facility_type, :street_line1, :street_line2, :postal_code, :city, :searchable, :contact_name, :contact_email)
    end

    def clear_flash 
      flash.discard 
    end
  end
end
