# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def get_current_user
    session_id = cookies.signed[:session_id]
    redirect_to "/register" and return unless session_id

    session = Session.find(session_id)
    redirect_to "/register" and return unless session

    @current_user = session.user
  end
end
