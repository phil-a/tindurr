class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  
  # find user by sessionid if one exists and return
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_login
    if session[:user_id] == nil
      redirect_to root_path
    end
  end
  #makes current_user available to entire app
  helper_method :current_user
  helper_method :require_login
end
