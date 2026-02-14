class MembersController < ApplicationController
  before_action :set_dbprueba, only: [:show, :edit, :update, :destroy]
  # GET /dbpruebas
  # GET /dbpruebas.json
  def index
    @members = Member.all
  end

  # GET /dbpruebas/1
  # GET /dbpruebas/1.json
  def show
  end

  # GET /dbpruebas/new
  def new
    @dbprueba = Dbprueba.new
  end

  # GET /dbpruebas/1/edit
  def edit
  end

  # POST /dbpruebas
  # POST /dbpruebas.json
  def create
    @dbprueba = Dbprueba.new(dbprueba_params)

    respond_to do |format|
      if @dbprueba.save
        format.html { redirect_to @dbprueba, notice: 'Dbprueba was successfully created.' }
        format.json { render :show, status: :created, location: @dbprueba }
      else
        format.html { render :new }
        format.json { render json: @dbprueba.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dbpruebas/1
  # PATCH/PUT /dbpruebas/1.json
  def update
    respond_to do |format|
      if @dbprueba.update(dbprueba_params)
        format.html { redirect_to @dbprueba, notice: 'Dbprueba was successfully updated.' }
        format.json { render :show, status: :ok, location: @dbprueba }
      else
        format.html { render :edit }
        format.json { render json: @dbprueba.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dbpruebas/1
  # DELETE /dbpruebas/1.json
  def destroy
    @dbprueba.destroy
    respond_to do |format|
      format.html { redirect_to dbpruebas_url, notice: 'Dbprueba was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dbprueba
      @dbprueba = Dbprueba.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dbprueba_params
      params.require(:dbprueba).permit(:nombre)
    end
end
