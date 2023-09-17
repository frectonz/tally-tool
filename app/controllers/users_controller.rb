class UsersController < ApplicationController
  include Passwordless::ControllerHelpers

  def index
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in(build_passwordless_session(@user))
      redirect_to(@user, flash: { notice: 'Welcome!' })
    else
      render(:index)
    end
  end

  def show
  end

  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email)
    end
end
