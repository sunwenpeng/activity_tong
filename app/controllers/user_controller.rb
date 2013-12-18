class UserController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: [:login_page,:login,:enroll,:show_enroll_form,:modify_password_page,:modify_password_question_page,:modify_password_login_page,:customer_check,:answer_check,:user_check,:update]
  include(UserHelper)
  skip_before_filter :verify_authenticity_token, :only => [:customer_check ]
  def login_page
  end

  def show
      name = User.find(session[:current_user_id]).name
      flash[:notice2]= "你好," + name
      if params[:page]==nil
         @i=(params[:page].to_i)*10+1
      else
        @i= (params[:page].to_i-1)*10+1
      end
      @users =User.paginate(page:params[:page],per_page:10).where(:admin=>false)
      if params[:user_name]
         session[:current_user] = params[:user_name]
      end
      @activities=Activity.paginate(page:params[:page],per_page:10).where(:create_user=> session[:current_user])
      @current_bid = Bid.where(:user=>session[:current_user],:status=>'biding')[0]
  end

  def login
      user = User.where(:name => params[:@user][:name],:password => params[:@user][:password])
      if user.empty?
        flash[:notice0] = "用户名或密码错误！"
        redirect_to
      else
        session[:current_user_id] = user[0].id
        session[:current_user] = user[0].name
        if user[0].name == 'admin'
           redirect_to user_index_path(:id=> user[0].name)
        else
          redirect_to user_index_path(:id => user[0].name)
        end
      end
  end

  def logout
    session[:current_user_id] = nil
    session[:current_user] = nil
    redirect_to action:'login_page'
  end

  def enroll
    if params[:user][:name].empty?
      flash.now[:notice1] = "请输入用户名!"
      render action: 'show_enroll_form'
    else
      if User.where(:name => params[:user][:name]).empty?
        if params[:user][:password_init].empty?
          flash[:notice1] = "请输入密码!"
          render action: 'show_enroll_form'
        else
          if params[:user][:password_init]!= params[:user][:password]
            flash[:notice1] = "两次输入的密码不一样！"
            render action: 'show_enroll_form'
          else
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
        end
      else
        flash[:notice1] = "用户名已存在!"
        render action: 'show_enroll_form'
      end
    end
  end

  def show_enroll_form

  end

  def modify_password_login_page
  end

  def modify_password_question_page
    @question = User.find(session[:user_id]).password_question
  end

  def modify_password_page

  end



  def update
    if params[:@user][:password_init].empty?
       flash[:modify_password_notice]="密码不能为空"
       render action:'modify_password_page'
    else
      if params[:@user][:password_init] == params[:@user][:password]
        user = User.find(session[:user_id])
        user.password = params[:@user][:password]
        user.save
        session[:current_user_id] = user.id
        respond_to do |format|
            format.html { redirect_to user_index_path(:id =>user.id)}
            format.json { head :no_content }
        end
      else
        flash[:modify_password_notice]="两次密码输入的不一致，请重新输入!"
        render action:'modify_password_page'
      end
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
      if params[:page]==nil
        @i=(params[:page].to_i)*10+1
      else
        @i= (params[:page].to_i-1)*10+1
      end
      @bids= Bid.paginate(page:params[:page],per_page:10).where(:user=>session[:current_user],:activity=>params[:name])
  end

  def sign_up_list
      name = User.find(session[:current_user_id]).name
      flash[:notice2]= "你好," + name
      if params[:page]==nil
        @i=(params[:page].to_i)*10+1
      else
        @i= (params[:page].to_i-1)*10+1
      end
      @sign_ups= SignUp.paginate(page:params[:page],per_page:10).where(:user=>session[:current_user],:activity=>params[:name])
  end

  def bid_detail_list
      name = User.find(session[:current_user_id]).name
      flash[:notice2]= "你好," + name
      if params[:page]==nil
        @i=(params[:page].to_i)*10+1
      else
        @i= (params[:page].to_i-1)*10+1
      end
      @bid_ups= BidUp.paginate(page:params[:page],per_page:10).where(:user=>session[:current_user],:activity=>params[:name],:bid_name=>params[:bid_name])
      result = BidResult.where(:activity=>params[:name],:bid_name=>params[:bid_name],:user=>session[:current_user])
      if result.empty?
        @message2 = '活动正在进行中......'
      else
        if result[0][:price] == -1
          @message2 = '本次竞价无人胜出！'
        else
          @message1 = '获胜者:'+result[0][:name]
          @message2 = '出价:'+ result[0][:price].to_s
          @message3 = '手机号:'+result[0][:phone]
        end
      end
      bid_statistics = @bid_ups.select(:price).group(:price)
      bid_statistics.each do |bs|
          bs[:price_number] = @bid_ups.where(:price=>bs.price).length
      end
      @bid_statistics = bid_statistics
  end

  def synchronously_show
    @bid = Bid.where(:user=>session[:current_user]).last
    @bid_ups= BidUp.paginate(page:params[:page],per_page:10).where(:user=>session[:current_user],:activity=>@bid[:activity],:bid_name=>@bid[:name])
    @info1=@bid.activity
    if @bid.status=='biding'
      @info2='参与人数:'+(@bid_ups.length).to_s+'/'+SignUp.where(:user=>session[:current_user],:activity=>@bid[:activity]).length.to_s
    else
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
  end



  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :password, :password_question, :password_question_answer)
  end

  def require_login
     unless session[:current_user_id]!=nil
         redirect_to action:'login_page'
     end
  end
end
