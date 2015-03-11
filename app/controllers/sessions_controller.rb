class SessionsController < ApplicationController
  before_action :require_not_logged_in, only: [:new, :create]

  def new
    render :new
  end

  def create
    user_name, password = params[:user][:user_name], params[:user][:password]
    @user = User.find_by_credentials(user_name, password)
    if @user
      login_user!(@user)
      redirect_to cats_url
    else
      flash.now[:errors] ||= []
      flash.now[:errors] << "Invalid login"
      render :new
    end
  end

  def destroy
    current_user.reset_session_token!
    session[:token] = nil

    redirect_to root_url
  end
end
