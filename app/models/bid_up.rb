class BidUp < ActiveRecord::Base
   def self.update_user_bid_ups(params)
     BidUp.delete_all(:user => params[:_json][5])
     bid_ups = params[:_json][3]
     bid_ups.each do |bu|
       bid_up= BidUp.new(:name=>bu[:name],:phone=>bu[:phone],:activity=>bu[:activity],:bid_name=>bu[:bid_name],:price=>bu[:price].to_i,:user=>bu[:user])
       bid_up.save
     end
   end
end
