class CreateRequestProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :request_products do |t|
      t.references :requests, foreign_key: true, null: false
      t.references :products, foreign_key: true, null: false
      t.integer :quantity, null: false
      t.string :additional_information

      t.timestamps
    end
  end
end
