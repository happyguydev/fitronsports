class FacilityContactPerson < ActiveRecord::Migration[6.0]
  def change
    add_column :facilities, :contact_person, :string
    add_column :facilities, :contact_email, :string
  end
end
