class BidUp < ActiveRecord::Base
   def self.update_user_bid_ups(params)
     BidUp.delete_all(:user => params[:user])
     bid_ups = params[:bid_ups]
     bid_ups.each do |bu|
       bid_up= BidUp.new(:name=>bu[:name],:phone=>bu[:phone],:activity=>bu[:activity],
                         :bid_name=>bu[:bid_name],:price=>bu[:price].to_i,:user=>bu[:user])
       bid_up.save
     end
   end
end
