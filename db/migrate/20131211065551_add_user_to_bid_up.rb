class AddUserToBidUp < ActiveRecord::Migration
  def change
    add_column :bid_ups, :user, :string
  end
end
