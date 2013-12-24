class UserEnrollController < ApplicationController
  def enroll_name_check
    if params[:user][:name].empty?
      @enroll_error = 1
      return render action: 'show_enroll_form'
    end
    user_name_check
  end

  def user_name_check
    if User.where(:name => params[:user][:name])[0]!=nil
      @enroll_error = 2
      return render action: 'show_enroll_form'
    end
    password_empty_check
  end

  def password_empty_check
    if params[:user][:password].empty?
      @enroll_error = 3
      return render action: 'show_enroll_form'
    end
    password_same_check
  end

  def password_same_check
    if params[:user][:password]!= params[:user][:password_confirmation]
      @enroll_error = 4
      return render action: 'show_enroll_form'
    end
    enroll_success
  end

  def enroll_success
    @user = User.new(user_params)
    @user.save
    flash[:enroll_success] = true
    respond_to do |format|
        format.html {redirect_to  controller:'user',action: 'login_page'}
        format.json { render action: 'login_page', status: :created, location: @user }
    end
  end

  def enroll
    enroll_name_check
  end
  private
  def user_params
    params.require(:user).
        permit(:name, :password, :password_confirmation, :password_question, :password_question_answer)
  end
end

