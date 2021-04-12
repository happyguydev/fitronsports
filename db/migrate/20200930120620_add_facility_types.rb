class AddFacilityTypes < ActiveRecord::Migration[6.0]
  def change
    add_enum_value :facility_types, 'Schule'
    add_enum_value :facility_types, 'Sportplatz'
    add_enum_value :facility_types, 'Spielplatz'
    add_enum_value :facility_types, 'Andere'
  end
end
