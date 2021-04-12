class AddDeletedReports < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :deleted, :boolean, default: false
  end
end
