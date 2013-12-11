class ActivityController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:customer_data_update]
  def customer_data_update
    if params[:_json]!= nil
       Activity.delete_all(:create_user=> params[:_json][0][0][:user])
       activities = params[:_json][0]
       activities.each do |a|
          activity=Activity.new(:name=>a[:name],:status=>a[:status],:create_user=>a[:user])
          activity.save
       end
       SignUp.delete_all(:user => params[:_json][0][0][:user])
       signUps = params[:_json][1]
       signUps.each do |s|
         signUp= SignUp.new(:name=>s[:enroll_name],:phone=>s[:phone],:activity=>s[:activity],:user=>s[:user])
         signUp.save
       end
       Bid.delete_all(:user => params[:_json][0][0][:user])
       bids = params[:_json][2]
       bids.each do |b|
          bid= Bid.new(:name=>b[:name],:status=>b[:status],:activity=>b[:activity],:user=>b[:user])
         bid.save
       end
       BidUp.delete_all(:user => params[:_json][0][0][:user])
       bid_ups = params[:_json][3]
       bid_ups.each do |bu|
         bid_up= BidUp.new(:name=>bu[:name],:phone=>bu[:phone],:activity=>bu[:activity],:bid_name=>bu[:bid_name],:price=>bu[:price],:user=>bu[:user])
         bid_up.save
       end
       respond_to do |f|
         f.json{render :json=>true}
       end
    else
      respond_to do |f|
        f.json{render :json => false}
      end
    end
  end

end
