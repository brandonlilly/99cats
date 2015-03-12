class SessionsController < ApplicationController
  before_action :require_not_logged_in, only: [:new, :create]
  before_action :require_logged_in, only: [:index]

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
    logout_user!(params[:id])
    if params[:id] == "0"
      redirect_to root_url
    else
      redirect_to sessions_url
    end
  end

  def index
    @sessions = current_user.sessions
    render :index
  end

end
