class UserEnrollController < ApplicationController
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
    if params[:user][:password].empty?
      flash[:notice1] = "请输入密码!"
      return render action: 'show_enroll_form'
    end
    password_same_check
  end

  def password_same_check
    if params[:user][:password]!= params[:user][:password_confirmation]
      flash[:notice1] = "两次输入的密码不一样！"
      return render action: 'show_enroll_form'
    end
    enroll_success
  end

  def enroll_success
    @user = User.new(user_params)
    @user.save
    flash[:notice] = "注册成功！请登录"
    respond_to do |format|
        format.html { redirect_to controller:'user',action: 'login_page'}
        format.json { render action: 'login_page', status: :created, location: @user }
    end
      #format.html { redirect_to 'user/login_page' }
      #format.json { render json: @user.errors, status: :unprocessable_entity }
  end

  def enroll
    enroll_name_check
  end
  private
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :password_question, :password_question_answer)
  end
end

