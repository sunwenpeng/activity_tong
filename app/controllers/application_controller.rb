class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def set_page
    if params[:page]==nil
      return (params[:page].to_i)*10+1
    end
    return (params[:page].to_i-1)*10+1
  end
end
