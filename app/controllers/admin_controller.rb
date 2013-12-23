class AdminController < ApplicationController
  before_action :require_login
  def admin_add_new_user
    @current_user = set_user_info
  end

  def admin_modify_password_page
    @current_user = set_user_info
  end

  def adminAddNewUser
    if params[:user][:name].empty?
      @error_message = 1
      @current_user = set_user_info
      return render action: 'admin_add_new_user'
    end
    user_name_same_check
  end

  def user_name_same_check
    if User.where(:name => params[:user][:name])[0]!=nil
       @error_message = 2
       @current_user = set_user_info
       return render action: 'admin_add_new_user'
    end
    user_password_check
  end

  def user_password_check
    if params[:user][:password].empty?
      @error_message = 3
      @current_user = set_user_info
      return render action: 'admin_add_new_user'
    end
    user_password_same_check
  end

  def user_password_same_check
    if params[:user][:password]!= params[:user][:password_confirmation]
      @error_message = 4
      @current_user = set_user_info
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
    if params[:@user][:password].empty?
      @admin_modify_password_error = 1
      @current_user= set_user_info
      return render action: 'admin_modify_password_page'
    end
    edit_password_check(user)
  end

  def edit_password_check(user)
    if params[:@user][:password] != params[:@user][:password_confirmation]
      @current_user= set_user_info
      @admin_modify_password_error = 2
      return render action: 'admin_modify_password_page'
    end
    update_users_password(user)
  end

  def update_users_password(user)
    user.password = params[:@user][:password]
    user.password_confirmation = params[:@user][:password_confirmation]
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
    params.require(:user).permit(:name, :password, :password_confirmation, :password_question, :password_question_answer)
  end

end
