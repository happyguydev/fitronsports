class AddActiveToAdmin < ActiveRecord::Migration[6.0]
  def change
    add_column :admins, :active, :boolean, default: true
  end
end
