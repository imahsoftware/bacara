class ParametrosController < ApplicationController
  before_action :set_parametro, only: [:edit, :update, :destroy]
  layout :d_layout
  before_action :checkaccess

  def checkaccess
    return is_permit('parametros')
  end

  def index
    if is_sygma
      @parametros = Parametro.all.order('id')
    else
      redirect_to root_path
    end
  end

  def new
    if is_sygma
      @parametro = Parametro.new
      render "parametro_form"
    else
      redirect_to root_path
    end
  end

  def edit
    if is_sygma
      respond_to do |format|
        format.html { render "parametro_form" }
      end
    else
      redirect_to root_path
    end
  end

  def create
    @parametro = Parametro.new(parametro_params)
    if @parametro.save
      flash[:notice] = "Creado con Exito."
      redirect_to edit_parametro_path(@parametro)
    else
      render action: "parametro_form"
    end
  end

  def update
    if @parametro.update(parametro_params)
      flash[:notice] = "Actualizado con Exito."
      redirect_to edit_parametro_path(@parametro)
    else
      render action: "parametro_form"
    end
  end

  def destroy
    @parametro.destroy
    respond_to do |format|
      format.html { redirect_to parametros_url }
    end
  end

  private
    def d_layout
      "application_admin"
    end

    def set_parametro
      @parametro = Parametro.find(params[:id])
    end

    def parametro_params
      params.require(:parametro).permit!
    end
end
