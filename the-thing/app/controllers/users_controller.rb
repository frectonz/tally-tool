# frozen_string_literal: true

class UsersController < ApplicationController
  def register_get
    @user = User.new
    render(:register)
  end

  def register_post
    @user = User.new(user_params)

    if @user.save
      session = @user.sessions.create
      SessionMailer.with(session:).login_email.deliver_later
      render(:email)
    else
      render(:register)
    end
  end

  def login_get
    render(:login)
  end

  def login_post
    @user = User.find_by(email: params[:email])

    if @user
      session = @user.sessions.create
      SessionMailer.with(session:).login_email.deliver_later
      render(:email)
    else
      @error = "user was not found"
      render(:login)
    end
  end

  def verify
    @session = Session.available.find_by(token: params[:token])

    if @session
      if @session.timed_out?
        @message = "Token timed out"
      else
        @message = "Valid token"
        @session.claim

        cookies.signed[:session_id] = {
          value: @session.id,
          expires: 1.year.from_now
        }
      end
    else
      @message = "Token doesn't exist"
    end

    render :verify
  end

  private
    def user_params
      params.require(:user).permit(:username, :email)
    end
end
