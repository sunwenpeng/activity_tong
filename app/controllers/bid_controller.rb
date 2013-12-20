class BidController < ApplicationController
  def bid_list
    name = User.find(session[:current_user_id]).name
    flash[:notice2]= "你好," + name
    @i = set_page
    @bids= Bid.paginate(page:params[:page],per_page:10).where(:user=>session[:current_user],:activity=>params[:name])
  end

  def bid_detail_list
    name = User.find(session[:current_user_id]).name
    flash[:notice2]= "你好," + name
    @i= set_page
    @bid_ups= BidUp.paginate(page:params[:page],per_page:10).where(:user=>session[:current_user],:activity=>params[:name],:bid_name=>params[:bid_name])
    result = BidResult.where(:activity=>params[:name],:bid_name=>params[:bid_name],:user=>session[:current_user])
    set_bid_message(result)
    bid_statistics = @bid_ups.select(:price).group(:price)
    bid_statistics.each do |bs|
      bs[:price_number] = @bid_ups.where(:price=>bs.price).length
    end
    @bid_statistics = bid_statistics
  end

  def set_bid_message(result)
    if result.empty?
      return @message2 = '活动正在进行中......'
    end
    result_price_check(result)
  end

  def result_price_check(result)
    if result[0][:price] == -1
      return @message2 = '本次竞价无人胜出！'
    end
    set_suc_message(result)
  end

  def set_suc_message(result)
    @message1 = '获胜者:'+result[0][:name]
    @message2 = '出价:'+ result[0][:price].to_s
    @message3 = '手机号:'+result[0][:phone]
  end

end
