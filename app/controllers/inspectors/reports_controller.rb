module Inspectors
  class ReportsController < ApplicationController
    layout 'inspectors/dashboard'
    load_and_authorize_resource
    before_action :authenticate_account!
    respond_to :json, :html

    def index
    end

    def show
    end

    def new; end

    def edit; end

    def update
      respond_to do |format|
        if @report.update(report_params)
          # update attachments
          report_images_params[:attributes].each do |index, report_part_attributes|
            report_part_attributes[:images_attachments].each do |img_index, image_attributes|
              if image_attributes[:id].nil?
                @report.report_parts[index.to_i].images.attach(image_attributes[:image])
                @report.report_parts[index.to_i].images_attachments[img_index.to_i].update(note: image_attributes['note'])
              elsif image_attributes[:_destroy].nil?
                @report.report_parts[index.to_i].images_attachments[img_index.to_i].update(note: image_attributes['note'])
              else
                @report.report_parts[index.to_i].images_attachments[img_index.to_i].purge_later
              end
            end
          end

          if @report.status == 'draft'
            flash[:notice] = t("request.flash.updated")
          else
            flash[:notice] = t("request.flash.submitted")
          end
          format.json { render json: @report, location: inspectors_report_path(@report) }
          format.html { redirect_to inspectors_root_path }
        else
          format.html
          format.json { render json: @report.errors }
        end
      end
    end

    def destroy
      @report.destroy
      flash[:notice] = t("report.flash.destroyed", id: @report.id)

      redirect_to inspectors_dashboard_path
    end

    private

    def report_params
      params.require(:report).permit(
        :title,
        :facility_id,
        :status,
        signature_attributes: [:image],
        report_parts_attributes: [
          :id,
          :title, 
          :product_id,
          :description, 
          :rate, 
          :_destroy,
        ])
    end

    def report_images_params
      params.require(:report_parts).permit(attributes: [ images_attachments: [:id, :image, :note, :_destroy]]).to_h
    end
  end
end