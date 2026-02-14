class ObjetosController < ApplicationController
  before_action :set_objeto, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  before_action :checkaccess

  def checkaccess
    return is_permit('objetos')
  end

  def index
    if is_sygma
      @q = Objeto.ransack(params[:q])
      @objetos = @q.result.paginate(:page => params[:page], :per_page => 10)
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
      @active_record = Objeto.find(params[:active_id]) if params[:active_id].present?
      @objeto = Objeto.new
      respond_to { |format| format.js }
    else
      redirect_to root_path
    end
  end

  def edit
    if is_sygma
      @active_record = Objeto.find(params[:active_id]) if params[:active_id].present?
      @objeto = Objeto.find(params[:id])
      respond_to { |format| format.js }
    else
      redirect_to root_path
    end
  end

  def create
    @objeto = Objeto.new(objeto_params)
    respond_to do |format|
      if @objeto.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @objeto } }
      end
    end
  end

  def update
    respond_to do |format|
      if @objeto.update(objeto_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @objeto } }
      end
    end
  end

  def destroy
    @objeto.destroy
    flash['success'] = "Eliminado con exito"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_objeto
      @objeto = Objeto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def objeto_params
      params.require(:objeto).permit!
    end

    def set_layout
      if ['index', 'new'].include?(action_name)
        'application_admin'
      elsif ['edit'].include?(action_name)
        'application_users'
      else
        'application_admin'
      end
    end
end
