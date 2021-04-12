class RenameAdditionalNotes < ActiveRecord::Migration[6.0]
  def change
    rename_column :requests, :additonal_notes, :additional_notes
  end
end
