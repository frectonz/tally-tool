class UsersController < ApplicationController
  def register
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session = @user.sessions.create
      SessionMailer.with(session: session).login_email.deliver_later
      redirect_to("/", flash: { notice: 'Welcome!' })
    else
      render(:register)
    end
  end

  def dashboard
  end

  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :email)
    end
end
