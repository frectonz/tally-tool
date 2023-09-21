class SessionMailer < ApplicationMailer
  default from: "auth@example.com"

  def login_email
    @session = params[:session]
    @user = @session.user
    email = @user.email
    @url = "https://example.com/verify/#{@session.token}"
    mail(to: email, subject: "Login to Tally Tool")
  end
end
