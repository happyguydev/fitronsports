class AddDraftsToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :draft_id, :bigint
    add_column :requests, :published_at, :timestamp
    add_column :requests, :trashed_at, :timestamp
    add_foreign_key :requests, :drafts, column: :draft_id
  end
end
