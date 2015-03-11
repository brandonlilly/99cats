class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by_session_token(session[:token])
  end

  def login_user!(user)
    user.reset_session_token!
    session[:token] = user.session_token
  end

  def logged_in?
    !!current_user
  end

  def require_not_logged_in
    if logged_in?
      flash[:warnings] = "You're already logged in."
      redirect_to root_url
    end
  end

end
