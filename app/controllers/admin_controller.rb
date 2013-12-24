class AdminController < ApplicationController
  def admin_add_new_user
    @current_user = set_user_info
  end

  def admin_modify_password_page
    @current_user = set_user_info
  end

  def adminAddNewUser
    if params[:user][:name].empty?
      @error_message = 'empty_user'
      @current_user = set_user_info
      return render action: 'admin_add_new_user'
    end
    user_name_same_check
  end

  def user_name_same_check
    if User.where(:name => params[:user][:name])[0]!=nil
       @error_message = 'used_name'
       @current_user = set_user_info
       return render action: 'admin_add_new_user'
    end
    user_password_check
  end

  def user_password_check
    if params[:user][:password].empty?
      @error_message = 'empty_password'
      @current_user = set_user_info
      return render action: 'admin_add_new_user'
    end
    user_password_same_check
  end

  def user_password_same_check
    if params[:user][:password]!= params[:user][:password_confirmation]
      @error_message = 'different_password'
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
      @admin_modify_password_error = 'empty_input'
      @current_user= set_user_info
      return render action: 'admin_modify_password_page'
    end
    edit_password_check(user)
  end

  def edit_password_check(user)
    if params[:@user][:password] != params[:@user][:password_confirmation]
      @current_user= set_user_info
      @admin_modify_password_error = 'different_input'
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
end
