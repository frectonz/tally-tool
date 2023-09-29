# frozen_string_literal: true

class NamespacesController < ApplicationController
  before_action :get_current_user
  before_action :set_namespace, only: %i[show edit update destroy]

  # GET /namespaces or /namespaces.json
  def index
    @namespaces = @current_user.namespaces.all
  end

  # GET /namespaces/1 or /namespaces/1.json
  def show; end

  # GET /namespaces/new
  def new
    @namespace = @current_user.namespaces.new
  end

  # GET /namespaces/1/edit
  def edit; end

  # POST /namespaces or /namespaces.json
  def create
    @namespace = @current_user.namespaces.new(namespace_params)

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
      @namespace = @current_user.namespaces.find_by(id: params[:id]) ||
                   @current_user.namespaces.find_by(name: params[:id])

      return if @namespace

      render json: { error: "Namespace not found" }, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def namespace_params
      params.require(:namespace).permit(:name, :action_quota)
    end
end
