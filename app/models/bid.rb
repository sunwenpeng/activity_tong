class Bid < ActiveRecord::Base
  def self.bid_update_user_data(params)
    Bid.delete_all(:user => params[:_json][5])
    bids = params[:_json][2]
    bids.each do |b|
      bid= Bid.new(:name=>b[:name],:status=>b[:status],:activity=>b[:activity],:user=>b[:user])
      bid.save
    end
  end
end
