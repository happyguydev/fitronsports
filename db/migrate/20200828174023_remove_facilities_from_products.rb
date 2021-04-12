class RemoveFacilitiesFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :facilities_id, :bigint
  end
end
