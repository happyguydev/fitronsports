module Admins
  class RequestsController < ApplicationController
    layout 'admins/dashboard', except: %i[show_public]
    before_action :set_request, only: %i[complete destroy show]
    before_action :clear_flash
    before_action :authenticate_admin!, except: %i[show_public]
    respond_to :json, :html, :pdf

    def index
      @requests = Request.active.where.not(status: :draft)
      if params[:query]
        return @requests if params[:query] == 'all'
        @requests = @requests.where(status: params[:query])
      else
        @requests = @requests.where(status: 'sent')
      end
    end

    def show; end

    def show_public
      @request = Request.find_by_uid(params[:id])
      respond_to do |format|
          format.html
          # format.pdf do
          #   $docraptor = DocRaptor::DocApi.new
          #     begin
          #       send_data(GeneratePdfJob.perform_now(@request, $docraptor, request.original_url.to_s.chomp('.pdf')), filename: "#{@request.title}.pdf", type: 'application/pdf')
          #     rescue DocRaptor::ApiError => error
          #       puts "#{error.class}: #{error.message}"
          #       puts error.code          # HTTP response code
          #       puts error.response_body # HTTP response body
          #       puts error.backtrace[0..3].join("\n")
          #       flash[:error] = "There was an error after trying to generate the pdf."
          #       redirect_to public_request_page_path(params[:id])
          #     end
          # end
      end
    end

    def destroy
      @request.delete_request
      redirect_to admins_requests_path, notice: t("admin.requests.flash.destroyed", id: @request.id)
    end

    def complete
      @request.complete_status!
      redirect_to admins_requests_path, notice: t("admin.requests.flash.completed", id: @request.id)
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    def clear_flash 
      flash.discard 
    end
  end
end
