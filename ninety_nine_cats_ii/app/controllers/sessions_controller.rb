class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    if user
      login_user!(user)
      redirect_to cats_url
    else
    raise "User not verified"
    end
  end

  def destroy
  end

  private
  def session_params
    params.require(:user).permit(:user_name, :password)
  end
end
