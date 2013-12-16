class AddPriceNumberToBidUp < ActiveRecord::Migration
  def change
    add_column :bid_ups, :price_number, :fixnum

  end
end
