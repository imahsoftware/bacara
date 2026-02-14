class UsersregistradosController < ApplicationController

  before_action :set_usersregistrado, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:confirmacion, :new, :finalizado, :create]

  layout :determine_layout

  # GET /usersregistrados
  # GET /usersregistrados.json
  def index
    @periodo = params[:periodo]
    if is_usersregistrado or is_becario
      sign_out current_user
      redirect_to root_path
      flash[:notice] = "ACCESO NO AUTORIZADO, Sesion Cerrada"
    end
    @q = Usersregistrado.where(["periodo = '#{@periodo}'"]).ransack(params[:q])
    @usersregistrados = @q.result.paginate(:page => params[:page], :per_page => 10).order("identificacion")
    @cantidad = Usersregistrado.where(["periodo = '#{@periodo}'"]).count
  end

  def confirmacion
    @user = User.find(params[:id])
    @user.activo = 'S'
    @user.confirmed_at = DateTime.now
    @user.save(validate: false)
    flash[:notice] = 'Correo confirmado correctamente'
    redirect_to root_path
  end

  def buscador
    @c = Usersregistrado.new
    @c.identificacion = params[:identificacion]
    @usersregistrados = Usersregistrado.search(@c)
    if @usersregistrados.count == 0
      flash[:notice] = "No hay resultados de la busqueda"
      redirect_to usersregistrados_path
    else
      if @usersregistrados.count == 1
        redirect_to edit_usersregistrado_path(id: @usersregistrados.first.id, etapa: "A")
      else
        respond_to do |format|
          format.html
        end
      end
    end
  end

  # def perido20182
  #   if is_usersregistrado or is_becario
  #     sign_out current_user
  #     redirect_to root_path
  #     flash[:notice] = "ACCESO NO AUTORIZADO, Sesion Cerrada"
  #   end
  #   @q = Usersregistrado.where(["periodo = '2018-2'"]).ransack(params[:q])
  #   @usersregistrados = @q.result.paginate(:page => params[:page], :per_page => 10)
  #   @periodo = params[:periodo]
  # end

  # GET /usersregistrados/1
  # GET /usersregistrados/1.json
  def show
  end

  def informesusersregistrados
  end

  def consolidado
    @periodo = params[:periodo]
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = "attachment; filename='Inscripciones_#{@periodo}_#{Time.now.strftime("%Y%m%d_%X")}.xls'"
    headers['Cache-Control'] = 'max-age=0'
    headers['pragma'] = "public"
    @usersregistrados = Usersregistrado.where(periodo: @periodo).all
  end

  # GET /usersregistrados/new
  def new
    @usersregistrado = Usersregistrado.new
    @usersregistrado.etapa = 'A'
    render :action => "usersregistrado_form"
  end

  def edit
    respond_to do |format|
      format.html {render :action => "usersregistrado_form"}
    end
  end

=begin
  def finalizado
    @usersregistrado = Usersregistrado.find(params[:id])
    @hc = "2019-09-09 23:59:59"
    if Time.now.strftime("%Y-%m-%d %X") >= @hc
      @mensaje = "Recuerda que para terminar el proceso deberas de ingresar a la plataforma con tu usuario y contraseña que acabas de registrar. "
    else
      @mensaje = "Has finalizado exitosamente el registro inicial, ahora con los datos registrados en la preinscripción puedes continuar
                  el proceso ingresando al portal de la corporación."
    end
  end
=end

  def create
    @usersregistrado = Usersregistrado.new(usersregistrado_params)
    if User.exists?(["upper(email) = upper('#{@usersregistrado.email.to_s}')"]) == false
      if @usersregistrado.save
        begin
          user = User.new
          user.portafolio_id = 2
          user.nombre = @usersregistrado.nombres.to_s
          user.username = @usersregistrado.email.to_s
          user.email = @usersregistrado.email.to_s
          user.password = @usersregistrado.password.to_s
          user.activo = 'N'
          user.sign_in_count = 1
          user.etapa =  'A'
          user.geintac =  'N'
          user.tipoconsulta = 'CLIENTE'
          user.save(validate: false)
        end
        if user
          ActiveRecord::Base.connection.execute("update usersregistrados set user_id = #{user.id} where id = #{@usersregistrado.id}")
        end
        UsersregistradoMailer.confirma(user,@usersregistrado).deliver_now
        flash[:notice] = "Usuario Registrado con exito !!!"
        redirect_to root_path
      else
        flash[:alert] = "Se produjo, favor validar los campos"
        render :action => "usersregistrado_form"
      end
    else
      flash[:alert] = 'Ya se encuentra registrado el correo electronico'
      render :action => "usersregistrado_form"
    end
  end

  def createpersona
    usersregistrados = Usersregistrado.where(["seleccionado = 'CAT' and persona_id is null"])
    usersregistrados.each do |usersregistrado|
      #gusersregistrado = Gusersregistrado.find(params[:id])
      user = User.find(usersregistrado.user_id)
      #if Persona.exists?(["upper(email) = upper('#{user.email.to_s}') and identificacion = '#{gusersregistrado.identificacion.to_s}'"]) == false
      if Persona.exists?(["identificacion = '#{usersregistrado.identificacion.to_s}'"]) == false
        persona = Persona.new
        persona.tipo_documento = usersregistrado.tipo_documento
        persona.identificacion = usersregistrado.identificacion
        persona.primer_nombre = usersregistrado.primer_nombre
        persona.segundo_nombre = usersregistrado.segundo_nombre
        persona.primer_apellido = usersregistrado.primer_apellido
        persona.segundo_apellido = usersregistrado.segundo_apellido
        persona.fecha_nacimiento = usersregistrado.fecha_nacimiento
        persona.estrato = usersregistrado.estrato
        persona.puntaje_sisben = usersregistrado.puntaje_sisben
        persona.programa_aspira = usersregistrado.programa_aspira
        persona.universidad1_id = usersregistrado.universidad1_id
        persona.universidad2_id = usersregistrado.universidad2_id
        persona.universidad3_id = usersregistrado.universidad3_id
        persona.institucion_id = usersregistrado.institucion_id
        persona.email = usersregistrado.email
        persona.email_confirma = usersregistrado.email_confirma
        persona.genero = usersregistrado.genero
        persona.direccion = usersregistrado.direccion
        persona.telefono = usersregistrado.telefono
        persona.celular = usersregistrado.celular
        persona.nombres_acud = usersregistrado.nombres_acud
        persona.documento_acud = usersregistrado.documento_acud
        persona.identificacion_acud = usersregistrado.identificacion_acud
        persona.telefono_acud = usersregistrado.telefono_acud
        persona.celular_acud = usersregistrado.celular_acud
        persona.email_acud = usersregistrado.email_acud
        persona.icfes = usersregistrado.icfes
        persona.municipio = usersregistrado.municipio_id
        persona.barrio_vereda = usersregistrado.barrio_vereda
        persona.presento = usersregistrado.presento
        persona.ocupacion = usersregistrado.ocupacion
        persona.presento2 = usersregistrado.presento2
        persona.presento3 = usersregistrado.presento3
        persona.anno_conv = '2019-2' # '2017'
        persona.otro_tel = usersregistrado.otro_tel
        persona.mat_grado9 = usersregistrado.mat_grado9
        persona.len_grado9 = usersregistrado.len_grado9
        persona.nat_grado9 = usersregistrado.nat_grado9
        persona.soc_grado9 = usersregistrado.soc_grado9
        persona.mat_grado10 = usersregistrado.mat_grado10
        persona.len_grado10 = usersregistrado.len_grado10
        persona.nat_grado10 = usersregistrado.nat_grado10
        persona.soc_grado10 = usersregistrado.soc_grado10
        persona.mat_grado11 = usersregistrado.mat_grado11
        persona.len_grado11 = usersregistrado.len_grado11
        persona.nat_grado11 = usersregistrado.nat_grado11
        persona.soc_grado11 = usersregistrado.soc_grado11
        persona.puntaje_icfes = usersregistrado.puntaje_icfes
        persona.cal2017_academico = usersregistrado.cal2017_academico
        persona.cal2017_estrato = usersregistrado.cal2017_estrato
        persona.cal2017_sisben = usersregistrado.cal2017_sisben
        persona.cal2017_cargo = usersregistrado.cal2017_cargo
        persona.cal2017_liderazgo = usersregistrado.cal2017_liderazgo
        persona.cal2017_total = usersregistrado.cal2017_total
        persona.liderazgo = usersregistrado.liderazgo
        persona.etapa = 'A'
        persona.seleccionado = 'SI'
        persona.universidad_id = usersregistrado.universidad_id
        persona.save(validate: false)
        if persona.id
          ActiveRecord::Base.connection.execute("update usersregistrados set persona_id = #{persona.id} where id =  #{usersregistrado.id}")
          ActiveRecord::Base.connection.execute("update users set persona_id = #{persona.id}, clase='BECARIO', activo = false
                                                   where id =  #{usersregistrado.user_id}")
          flash[:notice] = "Usuario Activado y listo para el proceso"
        else
          flash[:alert] = "Registro no activado, contacte al Administrador"
        end
      end
    end
    flash[:alert] = "Proceso Terminado"
    redirect_to authenticated_root_path
  end

  # PATCH/PUT /usersregistrados/1
  # PATCH/PUT /usersregistrados/1.json


  def update
    @usersregistrado = Usersregistrado.find(params[:id])
    params[:etapa].to_s != "" ? Usersregistrado.find(params[:id]).update_columns(etapa: params[:etapa].to_s) : nil
    if @usersregistrado.update_attributes(usersregistrado_params)
      flash[:notice] = "Actualizado con Exito"
      redirect_to edit_usersregistrado_path(@usersregistrado)
      #redirect_to finalizado_ausersregistrados_path(id: @ausersregistrado.id)
    else
      flash[:alert] = "Se produjo un error al actualizar, debes diligenciar todos los campos obligatorios."
      render :action => "usersregistrado_form"
    end
    #rescue
    #  redirect_to edit_ausersregistrado_path(@ausersregistrado)
  end

  # DELETE /usersregistrados/1
  # DELETE /usersregistrados/1.json
  def destroy
    @usersregistrado.destroy
    respond_to do |format|
      format.html {redirect_to usersregistrados_url, notice: 'Usersregistrado was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  def set_usersregistrado
    params[:etapa].to_s != "" ? Usersregistrado.find(params[:id]).update_columns(etapa: params[:etapa].to_s) : nil
    @usersregistrado = Usersregistrado.find(params[:id])
    if is_usersregistrado or is_becario
      if @usersregistrado.user_id != is_admin
        sign_out current_user
        redirect_to root_path
        flash[:notice] = "ACCESO NO AUTORIZADO, Sesion Cerrada"
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def usersregistrado_params
    params.require(:usersregistrado).permit!
  end

  def determine_layout
    if ['edit', 'update'].include?(action_name)
      "usersregistrado_layout"
    elsif ['index', 'perido20182'].include?(action_name)
      'application'
    elsif ['consolidado'].include?(action_name)
      'excel'
    else
      "inscripcion_layout"
    end
  end
end
