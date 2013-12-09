class UserController < ApplicationController
  include(UserHelper)

  def login_page
    if session[:current_user_id]==nil

    else
      redirect_to user_index_path(:id => session[:current_user_id])
    end
  end

  def show
    if session[:current_user_id] == nil
       redirect_to action:'login_page'
    else
      flash[:notice2]= "你好," + User.find(session[:current_user_id]).name
      @user =User.paginate(page:params[:page],per_page:9).where(:admin=>false)
    end
  end

  def login
      user = User.where(:name => params[:@user][:name],:password => params[:@user][:password])
      if user.empty?
        flash[:notice0] = "用户名或密码错误！"
        redirect_to
      else
        session[:current_user_id] = user[0].id
        if user[0].name == 'admin'
           redirect_to user_index_path(:id=> user[0].name)
        else
          redirect_to user_index_path(:id => user[0].name)
        end
      end
  end

  def logout
    session[:current_user_id] = nil
    redirect_to action:'login_page'
    puts "12432"
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

  def admin_modify_password_page
    if session[:current_user_id]==nil
      return redirect_to action:'login_page'
    end
  end

  def modify_password
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
    if session[:current_user_id]==nil
      return redirect_to action:'login_page'
    end
    User.delete params[:id]
    respond_to do |format|
      format.html { redirect_to user_index_path(:id=> session[:current_user_id]) }
      format.json { head :no_content }
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


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :password, :password_question, :password_question_answer)
  end
end
