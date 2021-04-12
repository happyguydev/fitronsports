class CreateReportParts < ActiveRecord::Migration[6.0]
  def change
    create_enum :report_statuses, %w[sent draft accept]
    create_table :reports do |t|
      t.bigint :inspector_account_id, null: false
      t.index :inspector_account_id
      
      t.references :facility, foreign_key: true, null: false
      t.string :title
      t.enum :status, as: :report_statuses, null: false, default: 'draft'

      t.datetime :sent_at
      t.datetime :accepted_at
      t.datetime :rejected_at
      t.datetime :trashed_at

      t.timestamps
    end

    create_enum :report_part_rates, %w[good problematic bad]
    create_table :report_parts do |t|
      t.references :report, foreign_key: true, null: false
      t.string :title
      t.string :description
      
      t.enum :rate, as: :report_part_rates, null: false, default: 'good'

      t.timestamps
    end
  end
end
