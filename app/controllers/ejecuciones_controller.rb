class EjecucionesController < ApplicationController
  before_action :set_ejecucion, only: [:show, :edit, :update, :destroy]

  # GET /ejecuciones
  # GET /ejecuciones.json
  def index
    @ejecuciones = Ejecucion.all
  end

  # GET /ejecuciones/1
  # GET /ejecuciones/1.json
  def show
  end

  # GET /ejecuciones/new
  def new
    @ejecucion = Ejecucion.new
  end

  # GET /ejecuciones/1/edit
  def edit
  end

  # POST /ejecuciones
  # POST /ejecuciones.json
  def create
    @ejecucion = Ejecucion.new(ejecucion_params)

    respond_to do |format|
      if @ejecucion.save
        format.html { redirect_to @ejecucion, notice: 'Ejecucion was successfully created.' }
        format.json { render :show, status: :created, location: @ejecucion }
      else
        format.html { render :new }
        format.json { render json: @ejecucion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ejecuciones/1
  # PATCH/PUT /ejecuciones/1.json
  def update
    respond_to do |format|
      if @ejecucion.update(ejecucion_params)
        format.html { redirect_to @ejecucion, notice: 'Ejecucion was successfully updated.' }
        format.json { render :show, status: :ok, location: @ejecucion }
      else
        format.html { render :edit }
        format.json { render json: @ejecucion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ejecuciones/1
  # DELETE /ejecuciones/1.json
  def destroy
    @ejecucion.destroy
    respond_to do |format|
      format.html { redirect_to ejecuciones_url, notice: 'Ejecucion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ejecucion
      @ejecucion = Ejecucion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ejecucion_params
      params.require(:ejecucion).permit(:user_id, :periodosliquidacion_id, :estado)
    end
end
