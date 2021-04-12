class FacitliySearchableActive < ActiveRecord::Migration[6.0]
  def change
    add_column :facilities, :active, :boolean, default: true
    add_column :facilities, :searchable, :boolean, default: true
  end
end
