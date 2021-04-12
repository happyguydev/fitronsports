module Janitors
  class RequestsController < ApplicationController
    layout 'janitors/dashboard'
    load_and_authorize_resource
    before_action :authenticate_account!
    respond_to :json, :html

    def index
      @requests = Request.accessible_by(current_ability).includes(:attachments)
    end

    def show; end

    def new
      @request = Request.new
    end

    def edit; end

    def update
      respond_to do |format|
        if @request.update(request_params)
          @request.attach_images(request_new_images_params[:images_attachments])
          @request.attachments_update(request_attached_images_params)

          if @request.status == 'draft'
            flash[:notice] = t("request.flash.updated")
          else
            flash[:notice] = t("request.flash.submitted")
          end
          format.json { render json: @request, location: janitors_request_path(@request) }
          format.html { redirect_to @request }
        else
          format.html
          format.json { render json: @request.errors }
        end
      end
    end

    def destroy
      @request.destroy
      flash[:notice] = t("request.flash.destroyed", id: @request.id)

      redirect_to janitors_dashboard_path
    end

    private

    def request_params
      params.require(:request).permit(
        :title,
        :description,
        :status,
        :product_quantity,
      )
    end

    def request_new_images_params
      if params.has_key?(:request_images)
        return params.require(:request_images).permit(
          images_attachments: %i[note blob]
          ).to_h
      end
      return {}
    end

    def request_attached_images_params
      if params.has_key?(:request_attached_images)
        return params.require(:request_attached_images).permit(
            images_attachments: %i[id note _destroy]
          ).to_h()[:images_attachments]
      end
      return {}
    end
  end
end
