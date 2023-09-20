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

  def verify
    @session = Session.available.find_by(token: params[:token])

    unless @session
      @message = "Token doesn't exist"
    else
      if @session.timed_out?
        @message = "Token timed out"
      else
        @message = "Valid token"
        @session.claim

        cookies.signed[:session_id] = {
          :value => @session.id,
          :expires => 1.year.from_now
        }
      end
    end

    render :verify
  end

  def dashboard
  end

  private
    def user_params
      params.require(:user).permit(:username, :email)
    end
end
