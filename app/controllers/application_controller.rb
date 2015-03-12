class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by_session_token(session[:token]).first
  end

  def login_user!(user)
    token = Session.generate_token
    Session.create!(user_id: user.id, token: token,
      environment: "#{browser.name} #{browser.full_version}")
    session[:token] = token
  end

  def logged_in?
    !!current_user
  end

  def logout_user!(session_id)
    if session_id == "0"
      current_session = current_user.sessions.find_by_token(session[:token])
    else
      current_session = current_user.sessions.find(session_id)
    end
    session[:token] = nil if current_session.token == session[:token]
    current_session.destroy!
  end

  def require_not_logged_in
    if logged_in?
      flash[:warnings] = "You're already logged in."
      redirect_to root_url
    end
  end

  def require_logged_in
    unless logged_in?
      flash[:warnings] = "You aren't logged in"
      redirect_to new_session_url
    end
  end

end
