class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.references :facilities, foreign_key: true, null: true
      t.string :title, null: false
      t.string :description, null: false
      t.integer :price_cents, null: false
      t.string :price_currency, limit: 3, null: false
      t.string :isbn
      t.string :sku

      t.timestamps
    end
  end
end
