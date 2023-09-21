class ApplicationController < ActionController::Base
  def get_current_user
    session_id = cookies.signed[:session_id]
    unless session_id
      redirect_to "/register" and return
    end

    session = Session.find(session_id)
    unless session
      redirect_to "/register" and return
    end

    @current_user = session.user
  end
end
