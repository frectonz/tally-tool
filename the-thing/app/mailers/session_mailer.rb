# frozen_string_literal: true

class SessionMailer < ApplicationMailer
  def login_email
    @session = params[:session]
    @url = "#{ENV["APP_URL"]}/verify/#{@session.token}"
    mail(to: @session.user.email, subject: "Login to Tally Tool")
  end
end
