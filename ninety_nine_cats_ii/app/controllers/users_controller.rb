class UsersController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.create
      redirect_to users_url(@user)
    else
      render :new
    end
  end

  def destroy
    if current_user
      current_user.reset_session_token
      session[:session_token] = nil
    end
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
