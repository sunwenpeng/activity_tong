class SignUpController < ApplicationController
  def sign_up_list
    name = User.find(session[:current_user_id]).name
    flash[:notice2]= "你好," + name
    @i = set_page
    @sign_ups= SignUp.paginate(page:params[:page],per_page:10).where(:user=>session[:current_user],:activity=>params[:name])
  end
end
