class BidResult < ActiveRecord::Base
  def self.update_user_bid_results(params)
    BidResult.delete_all(:user => params[:_json][5])
    bid_results = params[:_json][4]
    bid_results.each do |b_r|
      bid_result = BidResult.new(:activity=>b_r[:activity],:bid_name=>b_r[:name],:name=>b_r[:suc_person],:phone=>b_r[:phone],:price=>b_r[:price].to_i,:user=>b_r[:user])
      bid_result.save
    end
  end
end
