class MakeSentAtNullOnRequest < ActiveRecord::Migration[6.0]
  def change
    change_column_null :requests, :sent_at, true
  end
end
