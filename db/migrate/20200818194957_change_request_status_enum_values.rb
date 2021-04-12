class ChangeRequestStatusEnumValues < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_enum_value :request_statuses, 'draft'
    add_enum_value :request_statuses, 'sent'
  end
end
