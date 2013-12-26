class UserEnrollController < ApplicationController
  def show_enroll_form
    @user=User.new
  end

  def enroll
    @user = User.new(user_params)
    if @user.save
      flash[:enroll_success] = true
      respond_to do |format|
          format.html {redirect_to  controller:'user',action: 'login_page'}
          format.json { render action: 'login_page', status: :created, location: @user }
      end
    return
    end
    render action: 'show_enroll_form'
  end
end

