class ModulosController < ApplicationController
  before_action :set_modulo, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  before_action :checkaccess

  def checkaccess
    return is_permit('modulos')
  end

  def index
    if is_sygma
      @q = Modulo.ransack(params[:q])
      @modulos = @q.result.paginate(:page => params[:page], :per_page => 10)
      respond_to do |format|
        format.html
      end
    else
      redirect_to root_path
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    if is_sygma
      @active_record = Modulo.find(params[:active_id]) if params[:active_id].present?
      @modulo = Modulo.new
      respond_to { |format| format.js }
    else
      redirect_to root_path
    end
  end

  def edit
    if is_sygma
      @active_record = Modulo.find(params[:active_id]) if params[:active_id].present?
      @modulo = Modulo.find(params[:id])
      respond_to { |format| format.js }
    else
      redirect_to root_path
    end
  end

  def create
    @modulo = Modulo.new(modulo_params)
    respond_to do |format|
      if @modulo.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @modulo } }
      end
    end
  end

  def update
    respond_to do |format|
      if @modulo.update(modulo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @modulo } }
      end
    end
  end

  def destroy
    @modulo.destroy
    flash['success'] = I18n.t(:notice_elimina_msj)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modulo
      @modulo = Modulo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def modulo_params
      params.require(:modulo).permit!
    end

    def set_layout
      if ['index', 'new'].include?(action_name)
        'application_admin'
      elsif ['edit'].include?(action_name)
        'application_users'
      else
        'application'
      end
    end
end
