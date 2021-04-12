class AddTosAgreedToOnAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :terms_of_service, :boolean, null: false, default: false
  end
end
