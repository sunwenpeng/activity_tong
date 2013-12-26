class SignUpController < ApplicationController
  def sign_up_list
    @current_user=set_user_info
    @count_init = set_page
    @sign_ups= SignUp.paginate(page:params[:page],per_page:10).
        where(user:session[:current_user],activity:params[:name])
  end
end
