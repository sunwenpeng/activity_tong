class BidController < ApplicationController
  def bid_list
    @current_user=set_user_info
    @count_init = set_page
    @bids= Bid.paginate(page:params[:page],per_page:10).
        where(user:session[:current_user],activity:params[:name])
  end

  def bid_detail_list
    @current_user=set_user_info
    @count_init= set_page
    @bid_ups= BidUp.paginate(page:params[:page],per_page:10).
        where(user:session[:current_user],activity:params[:name],bid_name:params[:bid_name])
    result = BidResult.find_by(activity:params[:name],bid_name:params[:bid_name],
                             user:session[:current_user])
    set_bid_message(result)
    bid_statistics = @bid_ups.select(:price).group(:price)
    bid_statistics.each do |bs|
      bs[:price_number] = @bid_ups.where(price:bs.price).length
    end
    @bid_statistics = bid_statistics
  end

  def set_bid_message(result)
    if result == nil
      return @bid_result = 'biding'
    end
    result_price_check(result)
  end

  def result_price_check(result)
    if result[0][:price] == -1
      return @bid_result = false
    end
    set_suc_message(result)
  end

  def set_suc_message(result)
    @bid_result = true
    @bid_suc_person = result[0][:name]
    @bid_suc_price = result[0][:price].to_s
    @bid_suc_phone = result[0][:phone]
  end

end