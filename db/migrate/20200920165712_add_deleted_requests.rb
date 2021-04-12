class AddDeletedRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :deleted, :boolean, default: false
  end
end
