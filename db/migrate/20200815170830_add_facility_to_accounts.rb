class AddFacilityToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_reference :accounts, :facility, null: true, foreign_key: true
  end
end
