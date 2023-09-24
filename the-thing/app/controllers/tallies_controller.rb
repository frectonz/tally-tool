class TalliesController < ApplicationController
  before_action :set_namespace
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  # GET /namespaces/:id/tallies/
  def index
    render json: @namespace.tallies, status: :ok
  end

  # GET /namespaces/:id/tallies/:id
  def show
    tally_name = params[:id]

    actions_cookie = "#{@namespace.name}_#{tally_name}-actions"
    user_actions = (cookies[actions_cookie] || "0").to_i

    tally = @namespace.tallies.find_by(name: tally_name) || @namespace.tallies.new(name: tally_name)
    completed = user_actions >= @namespace.action_quota

    if tally.save()
      response_object = { tally: tally, completed: completed }
      render json: response_object, status: :ok
    else
      render json: tally.errors, status: :unprocessable_entity
    end
  end

  # POST /namespaces/:id/tallies
  def create
    tally = @namespace.tallies.new name: params[:name]

    if tally.save
      render json: tally, status: :created
    else
      render json: tally.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /namespaces/:id/tallies/:id?op=(INC|DEC)
  def update
    tally_name = params[:id]

    actions_cookie = "#{@namespace.name}_#{tally_name}-actions"
    user_actions = (cookies[actions_cookie] || "0").to_i

    if @namespace.action_quota != 0 and user_actions >= @namespace.action_quota
      render json: { error: "Reached action quota" } and return
    end

    tally = @namespace.tallies.find_by(name: tally_name) || @namespace.tallies.new(name: tally_name)
    operation = params[:op]

    case operation
    when "INC"
      tally.count += 1
    when "DEC"
      tally.count -= 1
    else
      render json: {
        error: "The `op` query parameter must be one of the following values: INC, DEC.",
      }, status: :bad_request and return
    end

    if tally.save()
      unless @namespace.action_quota == 0
        cookies[actions_cookie] = {
          :value => user_actions + 1,
          :expires => 1.year.from_now,
        }
      end

      completed = user_actions >= @namespace.action_quota
      response_object = { tally: tally, completed: completed }

      render json: response_object, status: :ok
    else
      render json: tally.errors, status: :unprocessable_entity
    end
  end

  private

  def set_namespace
    @namespace = Namespace.find_by(id: params[:namespace_id]) || Namespace.find_by(name: params[:namespace_id])
    if !@namespace
      render json: { error: "Namespace not found" }, status: :not_found
    end
  end
end
