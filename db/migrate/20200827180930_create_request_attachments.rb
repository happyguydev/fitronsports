class CreateRequestAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :request_attachments do |t|
      t.belongs_to :request, null: false, foreign_key: true
      t.jsonb :image
      t.integer :position
      t.string :note

      t.timestamps
    end
  end
end
