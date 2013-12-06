class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_action :require_login
  #
  #private
  #def require_login
  #  if session[:current_user] == nil
  #    flash[:notice] = "您必须先登录!"
  #    redirect_to 'login_page'
  #  end
  #end
  #
  #def current_user
  #  @_current_user ||= session[:current_user_id] && User.find_by(id: session[:current_user_id])
  #end


end
