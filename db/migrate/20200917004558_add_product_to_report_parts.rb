class AddProductToReportParts < ActiveRecord::Migration[6.0]
  def change
    ReportPart.delete_all
    change_table :report_parts do |t|
      t.references :product, foreign_key: true, null: false
    end
  end
end
