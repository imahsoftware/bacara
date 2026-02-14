class MunicipiosController < ApplicationController
  before_action :set_municipio, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('municipios')
  end

  def index
    @q = Municipio.ransack(params[:q])
    @municipios = @q.result.paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Municipio.find(params[:active_id]) if params[:active_id].present?
    @municipio = Municipio.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Municipio.find(params[:active_id]) if params[:active_id].present?
    @municipio = Municipio.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @municipio = Municipio.new(municipio_params)
    respond_to do |format|
      if @municipio.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @municipio } }
      end
    end
  end

  def update
    respond_to do |format|
      if @municipio.update(municipio_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @municipio } }
      end
    end
  end

  def destroy
    @municipio.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_municipio
    @municipio = Municipio.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def municipio_params
    params.require(:municipio).permit!
  end
end