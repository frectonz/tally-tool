class UsersController < ApplicationController
  def register
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # TODO: create passwordless session
      redirect_to(@user, flash: { notice: 'Welcome!' })
    else
      render(:register)
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email)
    end
end
