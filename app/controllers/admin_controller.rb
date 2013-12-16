class AdminController < ApplicationController
  def admin_add_new_user
    if session[:current_user_id]==nil
      return redirect_to action:'login_page'
    end
  end

  def adminAddNewUser
    if params[:user][:name].empty?
      flash.now[:add_error_notice] = "请输入用户名!"
      render action: 'admin_add_new_user'
    else
      if User.where(:name => params[:user][:name]).empty?
        if params[:user][:password_init].empty?
          flash[:add_error_notice] = "请输入密码!"
          render action: 'admin_add_new_user'
        else
          if params[:user][:password_init]!= params[:user][:password]
            flash[:add_error_notice] = "两次输入的密码不一样！"
            render action: 'admin_add_new_user'
          else
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
        end
      else
        flash[:add_error_notice] = "用户名已存在!"
        render action: 'admin_add_new_user'
      end
    end
  end

  def edit
    user = User.find(params[:id])
    if params[:@user][:password_init].empty?
      flash[:admin_modify_password_notice]="密码不能为空"
      flash[:notice2]= "你好," + User.find(session[:current_user_id]).name
      redirect_to
    else
      if params[:@user][:password_init] == params[:@user][:password]
        user.password = params[:@user][:password]
        user.save
        respond_to do |format|
          format.html { redirect_to user_index_path(:id=> session[:current_user_id])}
          format.json { head :no_content }
        end
      else
        flash[:admin_modify_password_notice]="两次密码输入的不一致，请重新输入!"
        flash[:notice2]= "你好," + User.find(session[:current_user_id]).name
        redirect_to
      end
    end
  end

  def show_user_page
    session[:current_user] = params[:user_name] ;
    redirect_to 'user/show'
  end
end
