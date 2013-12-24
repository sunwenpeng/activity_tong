class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :require_login   ,only: [:show,:add_new_user,:admin_add_new_user,:admin_modify_password_page,
  :adminAddNewUser,:edit,:bid_list,:bid_detail_list,:sign_up_list,:synchronously_show]
  protect_from_forgery with: :exception
  def set_page
    if params[:page]==nil
      return (params[:page].to_i)*10+1
    end
    return (params[:page].to_i-1)*10+1
  end

  def set_user_info
    return  User.find(session[:current_user_id]).name
  end

  private
  def require_login
    unless session[:current_user_id]!=nil
      redirect_to action:'login_page' , controller: 'user'
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation,
                                 :password_question, :password_question_answer)
  end
end
