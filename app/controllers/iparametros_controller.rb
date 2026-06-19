class IparametrosController < ApplicationController
  before_action :set_iparametro, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('iparametros')
  end

  def index
    @permiso = nil
    if Usersparametro.where("user_id = #{is_admin}").present?
      @parametro = 'ASIGNADO'
      @q = Iparametro.where("campo in (select campo from usersparametros where user_id = #{is_admin})").ransack(params[:q])
      @iparametros = @q.result.order("descripcion asc").paginate(:page => params[:page], :per_page => 50)
      respond_to do |format|
        format.html
      end
    elsif is_sygma
      @parametro = 'ADMIN'
      @q = Iparametro.ransack(params[:q])
      @iparametros = @q.result.order("descripcion asc").paginate(:page => params[:page], :per_page => 50)
      respond_to do |format|
        format.html
      end
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @parametro = nil
    if Usersparametro.where("user_id = #{is_admin}").present?
      @parametro = 'ASIGNADO'
    elsif is_sygma
      @parametro = 'ADMIN'
    end

    @active_record = Iparametro.find(params[:active_id]) if params[:active_id].present?
    @iparametro = Iparametro.new
    respond_to { |format| format.js }
  end

  def agregar_usuario
    @iparametro = Iparametro.find(params[:id])
  end

  def agregar_formato
    @iparametro = Iparametro.find(params[:id])
  end

  def edit
    @parametro = nil
    if Usersparametro.where("user_id = #{is_admin}").present?
      @parametro = 'ASIGNADO'
    elsif is_sygma
      @parametro = 'ADMIN'
    end
    @active_record = Iparametro.find(params[:active_id]) if params[:active_id].present?
    @iparametro = Iparametro.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @iparametro = Iparametro.new(iparametro_params)
    respond_to do |format|
      if @iparametro.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @iparametro } }
      end
    end
  end

  def update
    respond_to do |format|
      if @iparametro.update(iparametro_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @iparametro } }
      end
    end
  end

  def destroy
    @iparametro.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_iparametro
    @iparametro = Iparametro.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def iparametro_params
    params.require(:iparametro).permit!
  end
end
