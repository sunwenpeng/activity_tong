class CreateBidUps < ActiveRecord::Migration
  def change
    create_table :bid_ups do |t|
          t.string :name
          t.string :phone
          t.string :activity
          t.string :bid_name
          t.string :price

    end
  end
end
