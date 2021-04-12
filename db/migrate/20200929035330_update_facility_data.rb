class UpdateFacilityData < ActiveRecord::Migration[6.0]
  def change
    Facility.update_all("facility_type='Fitnessstudio'")
  end
end
