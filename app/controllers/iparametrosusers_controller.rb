class IparametrosusersController < ApplicationController
  before_action :set_iparametrosuser, only: [:show, :edit, :update, :destroy]

  #before_action :checkaccess, only: [:index, :edit], if: :user_signed_in?

  def checkaccess
    return is_permit('iparametrosusers')
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Iparametrosuser.find(params[:active_id]) if params[:active_id].present?
    @iparametrosuser = Iparametrosuser.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Iparametrosuser.find(params[:active_id]) if params[:active_id].present?
    @iparametrosuser = Iparametrosuser.find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    @iparametro = Iparametro.find(params[:iparametro_id])
    @iparametrosuser = Iparametrosuser.new(iparametrosuser_params)
    @iparametrosuser.iparametro_id = @iparametro.id
    respond_to do |format|
      if @iparametrosuser.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @iparametrosuser } }
      end
    end
  end

  def update
    respond_to do |format|
      if @iparametrosuser.update(iparametrosuser_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @iparametrosuser } }
      end
    end
  end

  def destroy
    @iparametrosuser.destroy
    flash['success'] = 'Eliminado con Exito'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_iparametrosuser
    @iparametrosuser = Iparametrosuser.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def iparametrosuser_params
    params.require(:iparametrosuser).permit!
  end
end