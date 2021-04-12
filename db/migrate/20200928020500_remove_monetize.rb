class RemoveMonetize < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :price_cents
    remove_column :products, :price_currency
  end
end
