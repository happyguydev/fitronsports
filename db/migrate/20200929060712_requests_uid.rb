class RequestsUid < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :uid, :string
    add_column :reports, :uid, :string
  end
end