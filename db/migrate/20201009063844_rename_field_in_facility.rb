class RenameFieldInFacility < ActiveRecord::Migration[6.0]
  def change
    rename_column :facilities, :contact_person, :contact_name
  end
end
