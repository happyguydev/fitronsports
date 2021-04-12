class RemoveDraftsman < ActiveRecord::Migration[6.0]
  def change
    remove_column :requests, :draft_id, :bigint
    remove_column :requests, :published_at, :timestamp
    remove_column :requests, :trashed_at, :timestamp

    remove_column :reports, :trashed_at, :timestamp

    drop_table :drafts
  end
end
