class CreateFacilities < ActiveRecord::Migration[6.0]
  def change
    create_enum :facility_types, %w[school]

    create_table :facilities do |t|
      t.enum :facility_type, as: :facility_types
      t.string :name
      t.string :street_line1
      t.string :street_line2
      t.string :city
      t.string :postal_code
      t.decimal :lon, precision: 10, scale: 6
      t.decimal :lat, precision: 10, scale: 6

      t.timestamps
    end
  end
end
