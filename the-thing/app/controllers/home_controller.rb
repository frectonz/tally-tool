# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :get_current_user_or_nil

  # GET /
  def index; end
end
