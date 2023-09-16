class TalliesController < ApplicationController
  before_action :set_namespace
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  # GET /namespaces/:id/tallies/
  def index
    render json: @namespace.tallies, status: :ok
  end
  
  # GET /namespaces/:id/tallies/:id
  def show
    tally = @namespace.tallies.find_by(name: params[:id])

    if !tally
      render json: { error: 'Tally not found' }, status: :not_found
    end

    render json: @tally, status: :ok
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
    tally = @namespace.tallies.find_by(name: params[:id]) || @namespace.tallies.new(name: params[:id])
    operation = params[:op]

    case operation
    when 'INC'
      tally.count += 1
    when 'DEC'
      tally.count -= 1
    else
      render json: {
        error: 'The `op` query parameter must be one of the following values: INC, DEC.' 
      }, status: :bad_request and return
    end

    if tally.save()
      render json: tally, status: :ok
    else
      render json: tally.errors, status: :unprocessable_entity
    end
  end


  private
    def set_namespace
      @namespace = Namespace.find_by(id: params[:namespace_id]) || Namespace.find_by(name: params[:namespace_id])
      if !@namespace
        render json: { error: 'Namespace not found' }, status: :not_found
      end
    end  
end
