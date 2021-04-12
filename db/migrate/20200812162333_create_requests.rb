class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_enum :request_types, %w[service_request order_request]
    create_enum :request_statuses, %w[pending accepted rejected]

    create_table :requests do |t|
      t.bigint :janitor_account_id, null: false
      t.references :facility, foreign_key: true, null: false
      t.enum :request_type, as: :request_types, null: false
      t.string :title
      t.string :description
      t.string :additonal_notes, array: true, default: []
      t.enum :status, as: :request_statuses, null: false, default: 'pending'
      t.datetime :sent_at, null: false
      t.datetime :accepted_at
      t.datetime :rejected_at

      t.timestamps
    end
  end
end
