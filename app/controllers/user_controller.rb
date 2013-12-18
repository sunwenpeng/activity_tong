class UserController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: [:user_params,:login_page,:login,:enroll,:show_enroll_form,:modify_password_page,:modify_password_question_page,:modify_password_login_page,:customer_check,:answer_check,:user_check,:update]
  include(UserHelper)
  skip_before_filter :verify_authenticity_token, :only => [:customer_check ]
  def login_page
  end

  def set_page
    if params[:page]==nil
      return (params[:page].to_i)*10+1
    end
    return (params[:page].to_i-1)*10+1
  end

  def show
      name = User.find(session[:current_user_id]).name
      flash[:notice2]= "你好," + name
      @i= set_page
      @users =User.paginate(page:params[:page],per_page:10).where(:admin=>false)
      if params[:user_name]
         session[:current_user] = params[:user_name]
      end
      @activities=Activity.paginate(page:params[:page],per_page:10).where(:create_user=> session[:current_user])
      @current_bid = Bid.where(:user=>session[:current_user],:status=>'biding')[0]
  end

  def user_empty_check(user)
     if user.empty?
       flash[:notice0] = "用户名或密码错误！"
       return redirect_to action: 'login'
     end
     go_to_user_index(user)
  end

  def go_to_user_index(user)
    session[:current_user_id] = user[0].id
    session[:current_user] = user[0].name
    redirect_to user_index_path(:id=> user[0].name)
  end

  def login
    user = User.where(:name => params[:@user][:name],:password => params[:@user][:password])
    user_empty_check(user)
  end

  def logout
    session[:current_user_id] = nil
    session[:current_user] = nil
    redirect_to action:'login_page'
  end

  def enroll_name_check
    if params[:user][:name].empty?
      flash.now[:notice1] = "请输入用户名!"
      return render action: 'show_enroll_form'
    end
    user_name_check
  end

  def user_name_check
    if User.where(:name => params[:user][:name])[0]!=nil
      flash[:notice1] = "用户名已存在!"
      return render action: 'show_enroll_form'
    end
    password_empty_check
  end

  def password_empty_check
    if params[:user][:password_init].empty?
      flash[:notice1] = "请输入密码!"
      return render action: 'show_enroll_form'
    end
    password_same_check
  end

  def password_same_check
    if params[:user][:password_init]!= params[:user][:password]
      flash[:notice1] = "两次输入的密码不一样！"
      return render action: 'show_enroll_form'
    end
    enroll_success
  end

  def enroll_success
    @user = User.new(user_params)
    flash[:notice] = "注册成功！请登录"
    respond_to do |format|
      if @user.save
        format.html { redirect_to action: 'login_page'}
        format.json { render action: 'login_page', status: :created, location: @user }
      else
        format.html { redirect_to action: 'login_page' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def enroll
     enroll_name_check
  end

  def modify_password_question_page
    @question = User.find(session[:user_id]).password_question
  end

  def update
    if params[:user][:password_init].empty?
       flash[:modify_password_notice]="密码不能为空"
       return render action:'modify_password_page'
    end
    update_password_check
  end

  def update_password_check
    if params[:user][:password_init] != params[:user][:password]
      flash[:modify_password_notice]="两次密码输入的不一致，请重新输入!"
      return render action:'modify_password_page'
    end
    update_user_password
  end

  def update_user_password
    user = User.find(session[:user_id])
    user.password = params[:user][:password]
    user.save
    session[:current_user_id] = user.id
    session[:current_user] = user.name
    respond_to do |format|
      format.html { redirect_to user_index_path(:id =>user.id)}
      format.json { head :no_content }
    end
  end

  def user_check
    if params[:@user][:name].empty?
      flash.now[:notice3] = "账户名不能为空!"
      render action: 'modify_password_login_page'
    else
      if User.where(:name => params[:@user][:name]).empty?
        flash.now[:notice3] = "账户名不存在!"
        render action: 'modify_password_login_page'
      else
        user = User.where(:name => params[:@user][:name])
        session[:user_id]= user[0].id
        redirect_to action: 'modify_password_question_page'
      end
    end
  end

  def answer_check
    usr= User.find(session[:user_id])
    if params[:@user][:password_question_answer] == usr.password_question_answer
      session[:user_id]=usr.id
      redirect_to action: 'modify_password_page'
    else
      flash[:notice5]="忘记密码答案错误"
      redirect_to
    end
  end

  def destroy
    User.delete params[:id]
    respond_to do |format|
      format.html { redirect_to user_index_path(:id=> session[:current_user_id]) }
      format.json { head :no_content }
    end
  end

  def customer_check
    user= User.where(:name => params[:name] , :password => params[:password])[0]
    respond_to do |format|
      if user.nil?
        format.json {render :json=> false}
      else
        random_number = SecureRandom.hex(10)
        user[:remember_token] = random_number
        user.save
        format.json {render :json=> random_number}
      end
    end
  end

  def bid_list
      name = User.find(session[:current_user_id]).name
      flash[:notice2]= "你好," + name
      @i = set_page
      @bids= Bid.paginate(page:params[:page],per_page:10).where(:user=>session[:current_user],:activity=>params[:name])
  end

  def sign_up_list
      name = User.find(session[:current_user_id]).name
      flash[:notice2]= "你好," + name
      @i = set_page
      @sign_ups= SignUp.paginate(page:params[:page],per_page:10).where(:user=>session[:current_user],:activity=>params[:name])
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

  def synchronously_show
    @bid = Bid.where(:user=>session[:current_user]).last
    @bid_ups= BidUp.paginate(page:params[:page],per_page:10).where(:user=>session[:current_user],:activity=>@bid[:activity],:bid_name=>@bid[:name])
    @info1=@bid.activity
    if @bid.status=='biding'
      return @info2='参与人数:'+(@bid_ups.length).to_s+'/'+SignUp.where(:user=>session[:current_user],:activity=>@bid[:activity]).length.to_s
    end
    set_bid_ended_inf
  end

  def set_bid_ended_info
    result = BidResult.where(:user=>session[:current_user],:activity=>@bid[:activity],:bid_name=>@bid[:name])[0]
    if result.price!=-1
      @info2='比赛结果'
      @info3='获胜者:' + result.name
      @info4='出价:' + result.price.to_s
      @info5='电话:' + result.phone
    end
    if result.price==-1
      @info2='竞价失败!'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :password, :password_question, :password_question_answer)
  end

  def require_login
     unless session[:current_user_id]!=nil
         redirect_to action:'login_page'
     end
  end
end
