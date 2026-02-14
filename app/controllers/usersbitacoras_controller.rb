class UsersbitacorasController < ApplicationController
  before_action :set_usersbitacora, only: [:show, :edit, :update, :destroy]

  def index
    @usersbitacoras = Usersbitacora.all
  end

  def show
  end

  def new
    @usersbitacora = Usersbitacora.new
  end

  def edit
  end

  def create
    @usersbitacora = Usersbitacora.new(usersbitacora_params)

    respond_to do |format|
      if @usersbitacora.save
        format.html { redirect_to @usersbitacora, notice: 'Usersbitacora was successfully created.' }
        format.json { render :show, status: :created, location: @usersbitacora }
      else
        format.html { render :new }
        format.json { render json: @usersbitacora.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @usersbitacora.update(usersbitacora_params)
        format.html { redirect_to @usersbitacora, notice: 'Usersbitacora was successfully updated.' }
        format.json { render :show, status: :ok, location: @usersbitacora }
      else
        format.html { render :edit }
        format.json { render json: @usersbitacora.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @usersbitacora.destroy
    respond_to do |format|
      format.html { redirect_to usersbitacoras_url, notice: 'Usersbitacora was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_usersbitacora
      @usersbitacora = Usersbitacora.find(params[:id])
    end

    def usersbitacora_params
      params.require(:usersbitacora).permit!
    end
end
