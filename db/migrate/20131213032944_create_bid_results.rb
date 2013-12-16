class CreateBidResults < ActiveRecord::Migration
  def change
    create_table :bid_results do |t|

      t.string :activity
      t.string :bid_name
      t.string :name
      t.string :phone
      t.float :price
      t.string :user
    end
  end
end
