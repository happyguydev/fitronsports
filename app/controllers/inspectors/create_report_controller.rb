module Inspectors
  class CreateReportController < ApplicationController
    before_action :authenticate_inspector!
    layout 'inspectors/create_report', except: [ :completion ]
    def new
      @facility = Facility.find(params[:facility_id]) if params[:facility_id]

      @report = Report.new
      @report.facility = @facility || nil
    end

    def create
      @report = current_inspector.reports.create!(report_params);
      respond_to do |format|
        format.html { redirect_to inspectors_root_path, notice: "Report created successfully!" }
        format.json { render json: edit_inspectors_report_path(@report) }
      end
    end

    def completion
      render layout: 'inspectors/overlay'
    end

    def saved_as_draft
      redirect_to inspectors_root_path, notice: t("create_report.saved_as_draft")
    end

    def cancel
      redirect_to inspectors_root_path, notice: t("create_report.cancel")
    end

    private
    def report_params
      params.require(:report).permit(
        :title,
        :facility_id,
        :status,
        signature_attributes: [:image],
        report_parts_attributes: [
          :title, 
          :product_id,
          :description, 
          :rate, 
          attachments_attributes: %i[image note]
        ])
    end
  end
end