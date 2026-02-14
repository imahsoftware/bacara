class IparametrosformatosController < ApplicationController
  before_action :set_iparametrosformato, only: [:show, :edit, :update, :destroy]

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Iparametrosformato.find(params[:active_id]) if params[:active_id].present?
    @iparametrosformato = Iparametrosformato.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Iparametrosformato.find(params[:active_id]) if params[:active_id].present?
    @iparametrosformato = Iparametrosformato.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @iparametro = Iparametro.find(params[:iparametro_id])
    @iparametrosformato = Iparametrosformato.new(iparametrosformato_params)
    @iparametrosformato.iparametro_id = @iparametro.id
    respond_to do |format|
      if @iparametrosformato.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @iparametrosformato } }
      end
    end
  end

  def update
    respond_to do |format|
      if @iparametrosformato.update(iparametrosformato_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @iparametrosformato } }
      end
    end
  end

  def destroy
    @iparametrosformato.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_iparametrosformato
    @iparametrosformato = Iparametrosformato.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def iparametrosformato_params
    params.require(:iparametrosformato).permit!
  end
end