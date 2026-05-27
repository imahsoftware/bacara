class ParametrosController < ApplicationController
  before_action :set_parametro, only: [:show, :edit, :update, :destroy]
  layout :d_layout
  before_action :checkaccess

  def checkaccess
    return is_permit('parametros')
  end

  def show
    respond_to { |format| format.js }
  end

  def index
    if is_sygma
      @parametros = Parametro.where(controlado: 'SI').order('id')
    else
      redirect_to root_path
    end
  end

  def new
    return redirect_to root_path unless is_sygma
    @active_record = Parametro.find(params[:active_id]) if params[:active_id].present?
    @parametro = Parametro.new
    respond_to { |format| format.js }
  end

  def edit
    return redirect_to root_path unless is_sygma
    @active_record = Parametro.find(params[:active_id]) if params[:active_id].present?
    respond_to { |format| format.js }
  end

  def create
    @parametro = Parametro.new(parametro_params)
    respond_to do |format|
      if @parametro.save
        flash[:notice] = I18n.t(:notice_crea_msj)
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @parametro } }
      end
    end
  end

  def update
    respond_to do |format|
      if @parametro.update(parametro_params)
        flash[:notice] = I18n.t(:notice_actualiza_msj)
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @parametro } }
      end
    end
  end

  def destroy
    @parametro.destroy
    respond_to do |format|
      format.html { redirect_to parametros_url }
      format.js
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
