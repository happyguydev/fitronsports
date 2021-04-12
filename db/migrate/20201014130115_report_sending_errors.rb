class ReportSendingErrors < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :failed_to_send, :boolean, default: false
  end
end
