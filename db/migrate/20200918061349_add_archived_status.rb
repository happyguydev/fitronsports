class AddArchivedStatus < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_enum_value :request_statuses, 'archived'
    add_enum_value :report_statuses, 'archived'
  end
end
