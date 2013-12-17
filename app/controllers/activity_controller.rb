class ActivityController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:customer_data_update]
  def customer_data_update
    if params[:_json]!= nil
       Activity.delete_all(:create_user=> params[:_json][5])
       activities = params[:_json][0]
       activities.each do |a|
          activity=Activity.new(:name=>a[:name],:status=>a[:status],:create_user=>a[:user])
          activity.save
       end
       SignUp.delete_all(:user => params[:_json][5])
       signUps = params[:_json][1]
       signUps.each do |s|
         signUp= SignUp.new(:name=>s[:enroll_name],:phone=>s[:phone],:activity=>s[:activity],:user=>s[:user])
         signUp.save
       end
       Bid.delete_all(:user => params[:_json][5])
       bids = params[:_json][2]
       bids.each do |b|
          bid= Bid.new(:name=>b[:name],:status=>b[:status],:activity=>b[:activity],:user=>b[:user])
         bid.save
       end
       BidUp.delete_all(:user => params[:_json][5])
       bid_ups = params[:_json][3]
       bid_ups.each do |bu|
         bid_up= BidUp.new(:name=>bu[:name],:phone=>bu[:phone],:activity=>bu[:activity],:bid_name=>bu[:bid_name],:price=>bu[:price].to_i,:user=>bu[:user])
         bid_up.save
       end
       BidResult.delete_all(:user => params[:_json][5])
       bid_results = params[:_json][4]
       bid_results.each do |b_r|
         bid_result = BidResult.new(:activity=>b_r[:activity],:bid_name=>b_r[:name],:name=>b_r[:suc_person],:phone=>b_r[:phone],:price=>b_r[:price].to_i,:user=>b_r[:user])
         bid_result.save
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
