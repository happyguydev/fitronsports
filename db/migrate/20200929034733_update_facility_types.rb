class UpdateFacilityTypes < ActiveRecord::Migration[6.0]
  def change
    add_enum_value :facility_types, 'Fitnessstudio'
  end
end
