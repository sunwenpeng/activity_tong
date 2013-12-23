class PhoneCustomerController < ApplicationController
  before_action :require_token ,:only => [:customer_data_update]
  skip_before_filter :verify_authenticity_token, :only => [:customer_data_update,:customer_check]
  def customer_data_update
    Activity.update_user_activities(params)
    SignUp.update_user_sign_ups(params)
    Bid.bid_update_user_data(params)
    BidUp.update_user_bid_ups(params)
    BidResult.update_user_bid_results(params)
    respond_to do |f|
      f.json{render :json=>true}
    end
  end

  def customer_check
    user= User.find_by_name(params[:name])
    respond_to do |format|
      if user && user.authenticate(params[:password])
        random_number = SecureRandom.hex(10)
        user[:remember_token] = random_number
        user.save
        format.json {render :json=> random_number}
      else
        format.json {render :json=> false}
      end
    end
  end

  private
  def require_token
    unless params[:token] == User.find_by(name:params[:_json][5])[:remember_token]
      respond_to do |f|
        f.json{render :json => false}
      end
    end
  end
end