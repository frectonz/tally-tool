# frozen_string_literal: true

class TalliesController < ApplicationController
  before_action :set_namespace
  before_action :set_tally, only: %i[show update]
  before_action :set_user_actions, only: %i[show update]
  skip_before_action :verify_authenticity_token, only: %i[create update]

  # GET /namespaces/:id/tallies/
  def index
    render json: @namespace.tallies, status: :ok
  end

  # GET /namespaces/:id/tallies/:id
  def show
    completed = if @namespace.action_quota == 0
      false
    else
      @user_actions >= @namespace.action_quota
    end

    if @tally.save
      response_object = { tally: @tally, completed: completed }
      render json: response_object, status: :ok
    else
      render json: @tally.errors, status: :unprocessable_entity
    end
  end

  # POST /namespaces/:id/tallies
  def create
    tally = @namespace.tallies.new(name: params[:name])

    if tally.save
      render json: tally, status: :created
    else
      render json: tally.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /namespaces/:id/tallies/:id?op=(INC|DEC)
  def update
    if (@namespace.action_quota != 0) && (@user_actions >= @namespace.action_quota)
      render json: { error: "Reached action quota" } and return
    end

    operation = params[:op]
    case operation
    when "INC"
      @tally.count += 1
    when "DEC"
      @tally.count -= 1
    else
      render json: {
        error: "The `op` query parameter must be one of the following values: INC, DEC."
      }, status: :bad_request and return
    end

    if @tally.save
      completed = if @namespace.action_quota == 0
        false
      else
        @user_actions + 1 >= @namespace.action_quota
      end

      response_object = { tally: @tally, completed: completed }
      render json: response_object, status: :ok
    else
      render json: @tally.errors, status: :unprocessable_entity
    end
  end

  private
    def set_namespace
      @namespace = Namespace.find_by(id: params[:namespace_id]) || Namespace.find_by(name: params[:namespace_id])
      return if @namespace

      render json: { error: "Namespace not found" }, status: :not_found
    end

    def set_tally
      @tally = @namespace.tallies.find_by(name: params[:id]) || @namespace.tallies.new(name: params[:id])
    end

    def set_user_actions
      user_actions = request.headers["X-User-Actions"]
      @user_actions = (user_actions || "0").to_i
    end
end
