class UserController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: [:user_params,:login_page,:login,:enroll,:show_enroll_form,:modify_password_page,:modify_password_question_page,:modify_password_login_page,:customer_check,:answer_check,:user_check,:update]
  include(UserHelper)
  skip_before_filter :verify_authenticity_token, :only => [:customer_check ]
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
    @bid_ups= BidUp.paginate(page:params[:page],per_page:10).where(:user=>session[:current_user],:activity=>@bid[:activity],:bid_name=>@bid[:name])
    @info1=@bid.activity
    if @bid.status=='biding'
      return @info2=(@bid_ups.length).to_s+'/'+SignUp.where(:user=>session[:current_user],:activity=>@bid[:activity]).length.to_s
    end
    set_bid_ended_info
  end

  def set_bid_ended_info
    @result = BidResult.where(:user=>session[:current_user],:activity=>@bid[:activity],:bid_name=>@bid[:name])[0]
    if @result.price!=-1
      @bid_success=true
      @info3= @result.name
      @info4=@result.price.to_s
      @info5= @result.phone
    end
    if @result.price==-1
      @bid_success=false
    end
  end



  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :password_question, :password_question_answer)
  end

  def require_login
     unless session[:current_user_id]!=nil
         redirect_to action:'login_page'
     end
  end
end
