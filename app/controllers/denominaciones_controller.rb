class DenominacionesController < ApplicationController
  before_action :require_sygma
  before_action :set_denominacion, only: [:edit, :update, :destroy, :act, :bact]

  def index
    @denominaciones = Denominacion.order(:nombre)
  end

  def new
    @denominacion = Denominacion.new(estado: 'ACTIVO')
  end

  def edit
  end

  def create
    @denominacion = Denominacion.new(denominacion_params)
    if @denominacion.save
      flash[:notice] = t(:notice_crea_msj)
      redirect_to denominaciones_path
    else
      render :new
    end
  end

  def update
    if @denominacion.update(denominacion_params)
      flash[:notice] = t(:notice_actualiza_msj)
      redirect_to denominaciones_path
    else
      render :edit
    end
  end

  def destroy
    # No se elimina si ya hay jugadas con esta denominación (se pierde historial);
    # en ese caso, se debe desactivar en vez de borrar.
    if @denominacion.jugadas.exists?
      flash[:alert] = t(:denomination_in_use_cannot_delete)
    else
      @denominacion.destroy
      flash[:notice] = t(:notice_elimina_msj)
    end
    redirect_to denominaciones_path
  end

  def act
    @denominacion.update(estado: 'ACTIVO')
    flash[:notice] = t(:activated_label)
    redirect_to denominaciones_path
  end

  def bact
    @denominacion.update(estado: 'INACTIVO')
    flash[:notice] = t(:inactivated_label)
    redirect_to denominaciones_path
  end

  private

  def require_sygma
    unless is_sygma
      flash[:warning] = t(:accion_no_permitida)
      redirect_to root_path
    end
  end

  def set_denominacion
    @denominacion = Denominacion.find(params[:id])
  end

  def denominacion_params
    params.require(:denominacion).permit(:nombre, :codigo, :simbolo, :estado)
  end
end
