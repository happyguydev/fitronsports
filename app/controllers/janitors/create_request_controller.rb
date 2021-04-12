module Janitors
  class CreateRequestController < ApplicationController
    include Wicked::Wizard
    before_action :authenticate_janitor!
    before_action :set_previous_step
    before_action :set_facility, only: :show
    skip_before_action :setup_wizard, only: [:cancel, :draft]
    layout 'janitors/create_request'

    steps :select_facility, :choose_type, :equipment_service, :product_order, :completion

    def show
      if step == :select_facility
        session[:request_params] = nil
        session[:request_completed_steps] = nil
      end
      session[:request_completed_steps] ||= {}
      session[:request_params] ||= default_request_params
      set_request

      if can_visit_step
        render_wizard
      else
        redirect_to wizard_path(:select_facility)
      end

      clear_wizard
    end

    def update
      session[:request_params].deep_merge!(request_params)
      set_request

      if @request.submit(savable_step?)
        session[:request_params] = nil if savable_step?

        completed!
        respond_to_wizard
      else
        render_validation_error errors: @request.errors
      end
    end

    # GET /create_request/cancel
    # GET /create_request/cancel.js
    def cancel
      respond_to do |format|
        if session[:request_params].present?
          session[:request_params] = nil
          session[:request_completed_steps] = nil

          format.html { redirect_to janitors_root_path, notice: t("create_request.completion.deleted") }
          format.js { flash[:notice] = t("create_request.completion.deleted") }
        else
          redirect_to wizard_path(:select_facility)
        end
      end
    end

    # GET /create_request/draft
    # GET /create_request/draft.js
    def draft
      session[:request_params] = nil
      session[:request_completed_steps] = nil

      redirect_to janitors_root_path, notice: t("create_request.completion.saved_as_draft")
    end

    private

    def set_facility
      if params[:facility_id]
        @facility = Facility.find(params[:facility_id])
        session[:request_params][:facility_id] = @facility.id
      end
    end

    def clear_wizard
      if completed?(:completion) && step != :completion
        session[:request_completed_steps] = nil
        session[:request_params] = nil
      end
    end

    def can_visit_step
      case step
      when :product_order, :equipment_service
        completed?(:choose_type)
      when :completion
        completed?(:product_order) || completed?(:equipment_service)
      when :choose_type
        completed?(:select_facility)
      when :select_facility
        true
      end
    end

    def set_previous_step
      @previous_step = case step
                       when :product_order, :equipment_service
                         :choose_type
                       when :choose_type
                         :select_facility
                      end
    end

    def completed?(step)
      session[:request_completed_steps].with_indifferent_access[step] == true
    end

    def completed!
      session[:request_completed_steps][step] = true
    end

    def set_request
      @request = CreateRequestForm.new session[:request_params]
      @request.current_step = step
      @request.janitor_id = current_janitor.id
    end

    def savable_step?
      step == :equipment_service || step == :product_order
    end

    def respond_to_wizard
      respond_to do |format|
        format.html { render_wizard }
        format.json { render json: { request: @request } }
        format.js { render_wizard @request, formats: :js }
      end
    end

    def default_request_params
      {
        facility_id: (@facility || current_janitor.facility)&.id,
        janitor_id: current_janitor.id
      }
    end

    def request_params
      params.require(:create_request_form)
            .permit(
              :facility_id,
              :request_type,
              :title,
              :description,
              :status,
              :product_quantity,
              :product_id,
              images_attachments: %i[note blob]
            )
    end
  end
end
