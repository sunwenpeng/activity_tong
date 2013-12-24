class UserController < ApplicationController
  include(UserHelper)
  skip_before_filter :verify_authenticity_token, :only => [:customer_check]
  def login_page
    if session[:current_user_id]!=nil
       redirect_to user_index_path(:id=> User.find(session[:current_user_id]).name)
    end
  end

  def show
      @current_user=set_user_info
      @count_init= set_page
      @users =User.paginate(page:params[:page],per_page:10).where(:admin=>false)
      if params[:user_name]
         session[:current_user] = params[:user_name]
      end
      @activities=Activity.paginate(page:params[:page],per_page:10).where(:create_user=> session[:current_user])
      @current_bid = Bid.where(:user=>session[:current_user],:status=>'biding')[0]
  end

  def user_empty_check(user)
     if user && user.authenticate(params[:@user][:password])
       return go_to_user_index(user)
     end
     @login_error = true
     render action: 'login_page'
  end

  def go_to_user_index(user)
    session[:current_user_id] = user.id
    session[:current_user] = user.name
    redirect_to user_index_path(:id=> user.name)
  end

  def login
    user = User.find_by_name(params[:@user][:name])
    user_empty_check(user)
  end

  def logout
    session[:current_user_id] = nil
    session[:current_user] = nil
    redirect_to action:'login_page'
  end

  def destroy
    User.delete params[:id]
    respond_to do |format|
      format.html { redirect_to user_index_path(:id=> session[:current_user_id]) }
      format.json { head :no_content }
    end
  end

  def synchronously_show
    @bid = Bid.where(:user=>session[:current_user]).last
    @bid_ups= BidUp.paginate(page:params[:page],per_page:10).
        where(:user=>session[:current_user],:activity=>@bid[:activity],:bid_name=>@bid[:name])
    @activity_number=@bid.activity
    if @bid.status=='biding'
      return @bid_number=(@bid_ups.length).to_s+'/'+SignUp.
          where(:user=>session[:current_user],:activity=>@bid[:activity]).length.to_s
    end
    set_bid_ended_info
  end

  def set_bid_ended_info
    @result = BidResult.where(:user=>session[:current_user],:activity=>@bid[:activity],:bid_name=>@bid[:name])[0]
    if @result.price!=-1
      @bid_success=true
      @bid_suc_person= @result.name
      @bid_suc_price=@result.price.to_s
      @bid_suc_phone= @result.phone
    end
    if @result.price==-1
      @bid_success=false
    end
  end

end
