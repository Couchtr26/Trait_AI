class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to chat_path
    else
      flash.now[:alert] = "Signup failed."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # IMPORTANT: we use email, not username
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
