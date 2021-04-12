class AddAttachableTypeToAttachments < ActiveRecord::Migration[6.0]
  def change
    remove_column :request_attachments, :request_id, :bigint
    
    add_column :request_attachments, :attachable_type, :string, null: false
    add_column :request_attachments, :attachable_id, :bigint, null: false
    add_index :request_attachments, [:attachable_type, :attachable_id]

    rename_table :request_attachments, :attachments
  end
end
