class PermisosController < ApplicationController
  before_action :set_permiso, only: [:asignar, :show, :edit, :update, :destroy]

  layout :set_layout
  before_action :checkaccess

  def checkaccess
    return is_permit('permisos')
  end

  def index
    if is_sygma
      @q = Permiso.ransack(params[:q])
      @permisos = @q.result.paginate(:page => params[:page], :per_page => 10)
      respond_to do |format|
        format.html
      end
    else
      redirect_to root_path
    end
  end

  def asignar
    @portafoliosasignados = Portafolio.where(["id in (select portafolio_id from portafoliospermisos where permiso_id = #{params[:id]})"])
  end

  def asignacion
    @portafolios = params[:portafoliospermiso][:portafolio_id].reject { |c| c.empty? }
    i = 0
    for i in 0..@portafolios.count-1
      @portafoliospermiso = Portafoliospermiso.new(portafoliospermiso_params)
      @portafoliospermiso.portafolio_id = @portafolios[i]
      @portafoliospermiso.permiso_id = params[:permiso_id]
      @portafoliospermiso.save
    end
    redirect_to asignar_permisos_path(id: params[:permiso_id])
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    if is_sygma
      @active_record = Permiso.find(params[:active_id]) if params[:active_id].present?
      @permiso = Permiso.new
      respond_to { |format| format.js }
    else
      redirect_to root_path
    end
  end

  def edit
    if is_sygma
      @active_record = Permiso.find(params[:active_id]) if params[:active_id].present?
      @permiso = Permiso.find(params[:id])
      respond_to { |format| format.js }
    else
      redirect_to root_path
    end
  end

  def create
    @permiso = Permiso.new(permiso_params)
    respond_to do |format|
      if @permiso.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @permiso } }
      end
    end
  end

  def update
    respond_to do |format|
      if @permiso.update(permiso_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @permiso } }
      end
    end
  end

  def destroy
    @permiso.destroy
    flash['success'] = I18n.t(:notice_elimina_msj)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permiso
      @permiso = Permiso.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def permiso_params
      params.require(:permiso).permit!
    end

    def portafoliospermiso_params
      params.require(:portafoliospermiso).permit!
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
