module Admins
  class ReportsController < ApplicationController
    layout 'admins/dashboard', except: %i[show_public]
    before_action :set_report, only: %i[complete destroy draft show]
    before_action :clear_flash
    before_action :authenticate_admin!, except: %i[show_public]
    respond_to :json, :html, :pdf

    def index
      @reports = Report.active.where.not(status: :draft)
      if params[:query]
        return @reports = @reports.where(failed_to_send: true) if params[:query] == 'failed'
        @reports = @reports.where(status: params[:query])
      end
    end

    def complete
      begin
        ReportsMailer.send_report(@report).deliver_now
        @report.accept!
        @report.update_attributes(sent_at: DateTime.current)
        flash[:success] = t("admin.reports.flash.completed", id: @report.id)
      rescue => error
        @report.update_attributes(failed_to_send: true)
        flash[:error] = t("admin.reports.flash.errors.completed", id: @report.id)
      end

      redirect_to admins_reports_path
    end

    def destroy
      @report.delete_report
      flash[:success] = t("admin.reports.flash.destroyed", id: @report.id)
      redirect_to admins_reports_path
    end

    def draft
      @report.draft!
      flash[:success] = t("admin.reports.flash.draft", id: @report.id)
      redirect_to admins_reports_path
    end

    def show; end

    def show_public
      @report = Report.find_by_uid(params[:id])
      respond_to do |format|
        format.html
        # format.pdf do
        #   $docraptor = DocRaptor::DocApi.new
        #     begin
        #       send_data(GeneratePdfJob.perform_now(@report, $docraptor, request.original_url.to_s.chomp('.pdf')), filename: "#{@report.title}.pdf", type: 'application/pdf')
        #     rescue DocRaptor::ApiError => error
        #       puts "#{error.class}: #{error.message}"
        #       puts error.code          # HTTP response code
        #       puts error.response_body # HTTP response body
        #       puts error.backtrace[0..3].join("\n")
        #       flash[:error] = "There was an error after trying to generate the pdf."
        #       redirect_to public_report_page_path(params[:id])
        #     end  
        # end
      end
    end

    private

    def set_report
      @report = Report.find(params[:id])
    end
    
    def clear_flash 
      flash.discard 
    end
  end
end
