class RemoveRequestProducts < ActiveRecord::Migration[6.0]
  def change
    drop_table :request_products

    change_table :requests do |t|
      t.references :product, foreign_key: true, null: true
      t.integer :product_quantity, default: 0
    end
  end
end
