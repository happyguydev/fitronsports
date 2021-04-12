class AddOrganisationToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :organisation_id, :bigint, after: :locked_at, null: true
    add_foreign_key :accounts, :organisations
  end
end
