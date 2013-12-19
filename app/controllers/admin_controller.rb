class AdminController < ApplicationController
  before_action :require_login
  def admin_add_new_user
  end

  def adminAddNewUser
    if params[:user][:name].empty?
      flash.now[:add_error_notice] = "请输入用户名!"
      return render action: 'admin_add_new_user'
    end
    user_name_same_check
  end

  def user_name_same_check
    if User.where(:name => params[:user][:name])[0]!=nil
        flash[:add_error_notice] = "用户名已存在!"
        return render action: 'admin_add_new_user'
    end
    user_password_check
  end

  def user_password_check
    if params[:user][:password_init].empty?
      flash[:add_error_notice] = "请输入密码!"
      return render action: 'admin_add_new_user'
    end
    user_password_same_check
  end

  def user_password_same_check
    if params[:user][:password_init]!= params[:user][:password]
      flash[:add_error_notice] = "两次输入的密码不一样！"
      return render action: 'admin_add_new_user'
    end
    add_new_user
  end

  def add_new_user
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_index_path(:id=>@user.name)}
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { redirect_to user_index_path(:id=>@user.name)}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    user = User.find(params[:id])
    if params[:@user][:password_init].empty?
      flash[:admin_modify_password_notice]="密码不能为空"
      flash[:notice2]= "你好," + User.find(session[:current_user_id]).name
      return redirect_to
    end
    edit_password_check(user)
  end

  def edit_password_check(user)
    if params[:@user][:password_init] != params[:@user][:password]
      flash[:admin_modify_password_notice]="两次密码输入的不一致，请重新输入!"
      flash[:notice2]= "你好," + User.find(session[:current_user_id]).name
      return redirect_to
    end
    update_users_password(user)
  end

  def update_users_password(user)
    user.password = params[:@user][:password]
    user.save
    respond_to do |format|
      format.html { redirect_to user_index_path(:id=> session[:current_user_id])}
      format.json { head :no_content }
    end
  end

  def show_user_page
    session[:current_user] = params[:user_name] ;
    redirect_to 'user/show'
  end

  private
  def require_login
    unless session[:current_user_id]!=nil
      redirect_to action:'login_page'
    end
  end

  def user_params
    params.require(:user).permit(:name, :password, :password_question, :password_question_answer)
  end

end
