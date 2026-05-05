class PortafoliosController < ApplicationController
  before_action :set_portafolio, only: [:show, :edit, :update, :destroy, :vertasas]

  layout :set_layout
  before_action :checkaccess

  def checkaccess
    return is_permit('portafolios')
  end

  def index
    # Antes: solo sygma veía la lista; los demás eran redirigidos al edit de su propio
    # portafolio. Ahora todos los usuarios con permiso al módulo /portafolios ven la lista.
    @q = Portafolio.ransack(params[:q])
    @portafolios = @q.result.paginate(:page => params[:page], :per_page => 10)
  end

  def vertasas
  end

  def new
    if is_sygma
      @portafolio = Portafolio.new
      @portafolio.etapa = 'A'
      render "portafolio_form"
    else
      redirect_to root_path
    end
  end

  def edit
    if is_sygma
      if @portafolio.etapa.to_s == "B"
        @portafoliospersonas = @portafolio.portafoliospersonas.all
      end
      respond_to do |format|
        format.html { render :action => "portafolio_form" }
      end
    else
      if is_portafolio == @portafolio.id
        if @portafolio.etapa.to_s == "B"
          #@portafoliossucursales = @portafolio.portafoliossucursales.all
        end
        respond_to do |format|
          format.html { render :action => "portafolio_form" }
        end
      else
        redirect_to root_path
      end
    end
  end

  def create
    @portafolio = Portafolio.new(portafolio_params)
    respond_to do |format|
      if @portafolio.save
        format.html { redirect_to edit_portafolio_path(etapa: "A", id: @portafolio.id), notice: I18n.t(:notice_crea_msj) }
        format.json { render :show, status: :created, location: @portafolio }
      else
        format.html { render :new }
        format.json { render json: @portafolio.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @portafolio.update(portafolio_params)
      flash[:notice] = I18n.t(:notice_actualiza_msj)
      redirect_to edit_portafolio_path(@portafolio)
    else
      @portafoliossucursal = Portafoliossucursal.new
      @portafolioscontrato = Portafolioscontrato.new
      @portafoliostasa = Portafoliostasa.new
      @portafoliostasascambio = Portafoliostasascambio.new
      @cliente = Cliente.new
      @portafoliostiposdocumento = Portafoliostiposdocumento.new
      @portafolioscuenta = Portafolioscuenta.new
      @portafolioscomision = Portafolioscomision.new
      @portafoliosobjeto = Portafoliosobjeto.new
      @portafoliosmodulos = Portafoliosmodulo.new
      render "portafolio_form"
    end
  end

  def destroy
    @portafolio.destroy
    flash[:notice] = I18n.t(:notice_elimina_msj)
    respond_to do |format|
      format.html { redirect_to(portafolios_url) }
      format.xml  { head :ok }
    end
  end

  def recalculargca
    @portafolio = Portafolio.find(params[:id])
    ActiveRecord::Base.connection.execute("update personassoblgcas set vmn = (capital * (#{@portafolio.vmn1.to_f}/100)), vmn2 = (capital * (#{@portafolio.vmn2.to_f}/100)), vmn3 = (capital * (#{@portafolio.vmn3.to_f}/100))")
    flash[:notice] = I18n.t(:values_recalculated_successfully)
    redirect_to portafolios_path
  end


  def usuarios
    @dato1s = User.where("portafolio_id = #{params[:id]} and (geintac = 'N' or geintac is null)").order(:nombre)
    respond_to do |format|
      format.xlsx{
        response.headers['Content-Disposition'] = 'attachment; filename="Imah_Usuarios_'+"#{Time.now.strftime("%Y%m%d_%X")}"+'.xlsx"'
      }
    end
  end

  def etapa
    params[:etapa].to_s != "" ? Portafolio.find(params[:id]).update_columns(etapa: params[:etapa].to_s) : nil
    redirect_to authenticated_root_path
  end

  private

    def set_layout
      if ['index', 'new'].include?(action_name)
        'application_admin'
      elsif ['edit'].include?(action_name)
        'application_portafolios'
      elsif ['vertasas'].include?(action_name)
        "agendas"
      else
        "application_admin"
      end
    end

    def set_portafolio
      params[:etapa].to_s != "" ? Portafolio.find(params[:id]).update_columns(etapa: params[:etapa].to_s) : nil
      @portafolio = Portafolio.find(params[:id])
    end

    def portafolio_params
      params.require(:portafolio).permit!
    end
end
