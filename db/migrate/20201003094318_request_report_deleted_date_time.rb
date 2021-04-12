class RequestReportDeletedDateTime < ActiveRecord::Migration[6.0]
  def change
    remove_column :reports, :deleted
    remove_column :requests, :deleted
    add_column :reports, :deleted, :datetime
    add_column :requests, :deleted, :datetime
  end
end
