class UserModifyPasswordController < ApplicationController
  def modify_password_question_page
    @question = User.find(session[:user_id]).password_question
  end

  def update
    if params[:user][:password].empty?
      flash[:user_modify_password_error] = true
      return render action:'modify_password_page'
    end
    update_password_check
  end

  def update_password_check
    if params[:user][:password] != params[:user][:password_confirmation]
      flash[:user_modify_password_error] = false
      return render action:'modify_password_page'
    end
    update_user_password
  end

  def update_user_password
    user = User.find(session[:user_id])
    user.password = params[:user][:password]
    user.password_confirmation = params[:user][:password_confirmation]
    user.save
    session[:current_user_id] = user.id
    session[:current_user] = user.name
    respond_to do |format|
      format.html { redirect_to user_index_path(id:user.id)}
      format.json { head :no_content }
    end
  end

  def user_check
    if params[:@user][:name].empty?
      @modify_login_error = 1
      return render action: 'modify_password_login_page'
    end
    modify_password_user_name_check
  end

  def modify_password_user_name_check
    if User.where(name: params[:@user][:name]).empty?
      @modify_login_error = 2
      return render action: 'modify_password_login_page'
    end
    user = User.where(name: params[:@user][:name])
    session[:user_id]= user[0].id
    redirect_to action: 'modify_password_question_page'
  end

  def answer_check
    usr= User.find(session[:user_id])
    if params[:@user][:password_question_answer] == usr.password_question_answer
      session[:user_id]=usr.id
      redirect_to action: 'modify_password_page'
    else
      flash[:modify_password_error] = true
      redirect_to
    end
  end
end
