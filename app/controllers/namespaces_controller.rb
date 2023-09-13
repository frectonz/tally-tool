class NamespacesController < ApplicationController
  before_action :set_namespace, only: %i[ show edit update destroy ]

  # GET /namespaces or /namespaces.json
  def index
    @namespaces = Namespace.all
  end

  # GET /namespaces/1 or /namespaces/1.json
  def show
  end

  # GET /namespaces/new
  def new
    @namespace = Namespace.new
  end

  # GET /namespaces/1/edit
  def edit
  end

  # POST /namespaces or /namespaces.json
  def create
    @namespace = Namespace.new(namespace_params)

    respond_to do |format|
      if @namespace.save
        format.html { redirect_to namespace_url(@namespace), notice: "Namespace was successfully created." }
        format.json { render :show, status: :created, location: @namespace }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @namespace.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /namespaces/1 or /namespaces/1.json
  def update
    respond_to do |format|
      if @namespace.update(namespace_params)
        format.html { redirect_to namespace_url(@namespace), notice: "Namespace was successfully updated." }
        format.json { render :show, status: :ok, location: @namespace }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @namespace.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /namespaces/1 or /namespaces/1.json
  def destroy
    @namespace.destroy

    respond_to do |format|
      format.html { redirect_to namespaces_url, notice: "Namespace was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_namespace
      @namespace = Namespace.find_by(id: params[:id]) || Namespace.find_by(name: params[:id])
      if !@namespace
        render json: { error: 'Namespace not found' }, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def namespace_params
      params.require(:namespace).permit(:name)
    end
end
