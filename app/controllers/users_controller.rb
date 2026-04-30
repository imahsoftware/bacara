class UsersController < ApplicationController
  before_action :set_user, only: [:desbloquearusuario, :desbloquearusuariop, :activaruser, :inactivaruser, :show, :edit, :update, :destroy]

  layout :set_layout
  autocomplete :user, :nombre

  autocomplete :identificacion, :nombredesbloquearusuario

  autocomplete :cambio, :user2

  before_action :checkaccess, except: [:cambioportafolio, :reestablecesusuario, :inconsistencias, :importar, :importar2, :carguemasivo, :fincargue, :cargar, :cargar2, :modograficoedu, :autocomplete_identificacion_nombre, :actemail, :updateemailedu, :edupol_resetpass, :edupol_desbloquearusuario, :modogestion, :cambiosucursal, :etapar, :etapa, :update, :cambiotipoconsulta], if: :user_signed_in?
  before_action :authenticate_user!, except: [:autocomplete_identificacion_nombre]

  def autocomplete_user_nombre
    term = params[:term]
    users = User.where('upper(username) LIKE ? OR upper(nombre) LIKE ? OR identificacion LIKE ?', "%#{replacespace(term.upcase)}%", "%#{replacespace(term.upcase)}%", "%#{replacespace(term.upcase)}%").limit(10).order(:nombre).all
    render :json => users.map { |user| { id: user.id, label: user.nombrecompleto, value: user.nombre } }
  end

  def autocomplete_cambio_user2
    term = params[:term]
    if params[:portafolio_id].to_s != "" or params[:portafolio_id].to_s != nil
      users = User.where('activo = ? and portafolio_id = ? and (upper(username) LIKE ? OR upper(identificacion) LIKE ? OR upper(nombre) LIKE ?)', "S", params[:portafolio_id].to_i, "%#{replacespace(term.upcase)}%", "%#{replacespace(term.upcase)}%", "%#{replacespace(term.upcase)}%").limit(10).order(:nombre).all
      render :json => users.map { |user| { id: user.id, label: user.nombrecompleto, value: user.nombre } }
    end
  end

  def cambiousuario
    if params[:user_id].to_s != ""
      @user = User.find(is_admin)
      @user.user2_id = params[:user_id].to_i
      ad = User.find(params[:user_id].to_i)
      @user.geintac = ad.geintac.to_s
      @user.tipoconsulta = ad.tipoconsulta.to_s
      @user.tipoconsultatmp = @user.tipoconsulta2.to_s
      @user.tipoconsulta2 = ad.tipoconsulta2.to_s
      @user.save(validate: false)
      redirect_to root_path
    end
  end

  def reestablecesusuario
    @user = User.find(current_user.id)
    @user.user2_id = nil
    @user.geintac = 'S'
    @user.tipoconsulta = 'TODO'
    @user.tipoconsulta2 = @user.tipoconsultatmp.to_s
    @user.tipoconsultatmp = nil
    @user.save(validate: false)
    redirect_to root_path
  end

  def autocomplete_identificacion_nombre
    term = params[:term]
    cohorte_id = params[:cohorte].to_i
    if params[:tipoconsulta] != "" or params[:tipoconsulta] != nil
      if cohorte_id != 0
        users = User.where('portafolio_id LIKE ? AND (tipoconsulta LIKE ? OR tipoconsulta2 LIKE ?) AND (upper(identificacion) LIKE ? OR upper(nombre) LIKE ?)', "%#{params[:portafolio_id]}%", "%#{params[:tipoconsulta]}%", "%#{params[:tipoconsulta]}%", "%#{replacespace(term.upcase)}%", "%#{replacespace(term.upcase)}%").order(:nombre).all
        render :json => users.map { |user| { id: user.id, label: user.nombre, value: user.id } }
      else
        users = User.where('activo = ? and portafolio_id LIKE ? AND (tipoconsulta LIKE ? OR tipoconsulta2 LIKE ?) AND (upper(identificacion) LIKE ? OR upper(nombre) LIKE ?)', "S", "%#{params[:portafolio_id]}%", "%#{params[:tipoconsulta]}%", "%#{params[:tipoconsulta]}%", "%#{replacespace(term.upcase)}%", "%#{replacespace(term.upcase)}%").order(:nombre).all
        render :json => users.map { |user| { id: user.id, label: user.nombre, value: user.id } }
      end
    end
  end

  def carguemasivo

  end

  def tabhome
    @user = User.find(params[:id])
    @user.hometab = params[:tab]
    @user.save(validate: false)
    redirect_to menus_path
  end

  def cargar
    @userporcrear = Migracionesuser.where("error is null and aplicado is null and userreg_id = #{is_admin}")
    @userporcrear.each do |u|
      user = User.new
      user.nombre = u.nombre.upcase
      user.identificacion = u.identificacion
      user.username = u.username
      user.email = u.email
      user.genero = u.genero
      user.portafoliossucursal_id = u.portafoliossucursal_id
      user.direccion = u.direccion
      user.ciudad = u.ciudad
      user.celular = u.celular
      user.telefonos = u.telefonos
      buser = User.find_by(identificacion: u.identificacion)
      if buser
        user.tipoconsulta2 = u.tipoconsulta
      else
        user.tipoconsulta = u.tipoconsulta
      end
      user.cargo_id = u.cargo_id
      user.centro_id = u.centro_id
      user.banco = u.banco_id
      user.municipio_id = u.municipio_id
      user.tipo_cuenta = u.tipo_cuenta
      user.nro_cuenta = u.nro_cuenta
      user.tipoconsulta = u.tipoconsulta
      user.extension = u.extension
      user.observaciones = u.observaciones
      user.password = u.password
      user.portafolio_id = u.portafolio_id
      user.activo = 'S'
      user.save(validate: false)
      u.aplicado = 'SI'
      u.save
    end
    flash[:notice] = 'Archivo Cargado con Exito...'
    if is_auth_c('cargacazadores')
      redirect_to descargaedupol_procesos_path
    else
      redirect_to users_path
    end
  end

  def cargar2
    @userporcrear = Migracionesuser.where("error is null and aplicado is null and userreg_id = #{is_admin}")
    @userporcrear.each do |u|
      buser = User.find_by(identificacion: u.identificacion)
      buser.activo = 'N'
      buser.save
    end
    flash[:notice] = 'Archivo Cargado con Exito...'
    if is_auth_c('cargacazadores')
      redirect_to descargaedupol_procesos_path
    else
      redirect_to users_path
    end
  end

  def inconsistencias
    @mconerror = Migracionesuser.where("error is not null and aplicado is null and userreg_id = #{is_admin}").order("id")
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = 'attachment; filename="Bacara_inconsistenciasUsers_' + "#{Time.now.strftime("%Y%m%d_%X")}" + '.xls"'
    headers['Cache-Control'] = 'max-age=0'
    headers['pragma'] = "public"
  end

  def checkaccess
    return is_permit('admin/users')
  end

  def actemail
    @user = User.find(params[:id])
    @persona = Persona.find(params[:persona_id])
  end

  def updateemailedu
    @email_actual = params[:email_actual].strip
    @user = User.find(params[:user][:id])
    existe = User.where(email: params[:user][:email].strip.split.first).exists?
    existe2 = User.where(username: params[:user][:email].strip.split.first).exists?
    if existe == false and existe2 == false
      if params[:user][:email] =~ /@/
        @user.username = params[:user][:email].strip.split.first
        @user.email = params[:user][:email].strip.split.first
        respond_to do |format|
          if @user.save(validate: false)
            persona = Persona.find(params[:user][:persona_id])
            persona.email = @user.email.strip.split.first
            persona.save(validate: false)
            format.js
            flash[:success] = 'Actualizado Correctamente'

            @registro = Registro.new
            @registro.modelo = 'ACTUALIZACIONEMAIL'
            @registro.estado = 'CORRECTO'
            @registro.user_id = @user.id
            @registro.usuario = @user.username
            @registro.save
          else
            format.js
          end
        end
      else
        flash[:warning] = 'Tiene que ser un Correo Electrónico'
      end
    elsif @user.email == params[:user][:email].strip
      flash[:warning] = 'Este es tu Correo Electrónico'
    else
      flash[:warning] = 'El Correo Electrónico ya fue tomado por otro Usuario'
    end
  end

  def show
  end

  def index
    @blockedusers = User.where(failed_attempts: 3).where.not(id: [1, 2])
    @q = User.ransack(params[:q])
    @users = @q.result.where.not(id: [1, 2]).paginate(:page => params[:page], :per_page => 10)
    @q = User.ransack(params[:q])

    if @q == nil
      @users = User.all.where.not(id: [1, 2]).paginate(:page => params[:page], :per_page => 10)
    else
      @users = @q.result.where.not(id: [1, 2]).paginate(:page => params[:page], :per_page => 10)
    end
    if params[:nombre]
      @users = User.name_like("%#{params[:nombre].upcase}%").where.not(id: [1, 2]).order(:nombre).paginate(:page => params[:page], :per_page => 10)
      if @users.count == 1
        @user = @users.last
        redirect_to edit_user_path(etapa: "A", id: params[:user_id])
      end
    else
    end
  end

  def new
    @user = User.new
    @user.etapa = 'A'
    render "user_form"
  end

  def edit
    if @user.etapa.to_s == 'F'
      @usersvehiculos = @user.usersvehiculos.all
    elsif @user.etapa.to_s == 'H'
      @usersportafolios = @user.usersportafolios.all
    elsif @user.etapa.to_s == 'G'
      @userssucursales = @user.userssucursales.all
    elsif @user.etapa.to_s == 'B'
      @usersmodulos = @user.usersmodulos.all
    elsif @user.etapa.to_s == 'I'
      @usersreportes = @user.usersreportes.all
    elsif @user.etapa.to_s == 'C'
      @userspermisos = @user.userspermisos.all
    elsif @user.etapa.to_s == 'C'
      @usersvisitas = @user.usersvisitas.all
    elsif @user.etapa.to_s == 'A'
    end
    #@usersfechas = @user.usersfechas.all
    #@usersimagenes = @user.usersimagenes.all
    respond_to do |format|
      format.html { render :action => "user_form" }
    end
  end

  def create
    @user = User.new(user_params)
    if is_sygma == false
      @user.portafolio_id = is_portafolio
    end
    if @user.save
      flash[:notice] = "Creado con Exito."
      redirect_to edit_user_path(etapa: "A", id: @user.id)
    else
      @user.etapa = 'A'
      render action: "user_form"
    end
  end

  def modogestion
=begin
    if params[:act].to_s == 'SI'
      @user = User.find(params[:id])
      @user.etapa = 'GE'
      @user.save
      flash['success'] = "Modo Gestión Activado"
      redirect_to root_path
    elsif params[:act].to_s == 'NO'
      @user = User.find(params[:id])
      @user.etapa = 'A'
      @user.save
      flash['success'] = "Modo Gestión Desactivado"
      redirect_to root_path
    end
=end
  end

  def modograficoedu
    if User.find(is_admin).estapaedu.to_s == 'ACTIVA'
      @user = User.find(params[:id])
      @user.estapaedu = 'INACTIVA'
      @user.save(validate: false)
      redirect_to root_path
    else
      @user = User.find(params[:id])
      @user.estapaedu = 'ACTIVA'
      @user.save(validate: false)
      redirect_to root_path
    end
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    if params[:user][:ingresoseguro].to_s == "NO"
      @user.encrypted_otp_secret = nil
      @user.encrypted_otp_secret_iv = nil
      @user.encrypted_otp_secret_salt = nil
      @user.consumed_timestep = nil
      @user.otp_required_for_login = nil
      @user.unconfirmed_otp_secret = nil
    end
    if @user.update(user_params)
      flash['success'] = "Usuario actualizado"
      if is_permit('admin/users') == true
        #ActiveRecord::Base.connection.execute("CALL prc_actperfilsupervisor()") if params[:process_action] != 'update_user'
        if params[:process_action] != 'update_user'
          redirect_to edit_user_path(id: @user.id, etapa: 'A')
        else
          redirect_to edit_user_registration_path
        end
      else
        redirect_to root_path
      end
    else
      render "user_form"
    end
  end

  def desbloquearusuario
    @user.failed_attempts = 0
    @user.unlock_token = nil
    @user.locked_at = nil
    @user.save(validate: false)
    flash['success'] = I18n.t(:user_unlocked_successfully)
    redirect_to users_path
  end

  def restableceyenvia
    @user = User.find(params[:id])
    @user.password = @user.identificacion
    @user.failed_attempts = 0
    @user.unlock_token = nil
    @user.locked_at = nil
    @user.save(validate: false)
    mensaje = "BACARA: Estimad@ #{@user.nombres}, nos permitimos enviar su usuario #{@user.identificacion} y contrasena #{@user.identificacion} para el ingreso a la plataforma de ASEAR, la cual sera una herramienta clave para el seguimiento y control de los colaboradores. - Url: https://appasearesp.com".html_safe
    Bacarasms::SendsmsServices.new.send_sms_users(@user.id, mensaje)
    flash['success'] = I18n.t(:user_unlocked_and_sms_sent, mobile: @user.celular.to_s)
    redirect_to users_path
  end

  def desbloquearusuariop
    @user.failed_attempts = 0
    @user.unlock_token = nil
    @user.locked_at = nil
    @user.save(validate: false)
    flash['success'] = I18n.t(:user_unlocked_successfully)
    redirect_to personas_path
  end

  def desbloquearusuariof
    usrs = User.where(["unlock_token is not null"])
    usrs.each do |u|
      u.failed_attempts = 0
      u.unlock_token = nil
      u.locked_at = nil
      u.save(validate: false)
    end
    flash['success'] = I18n.t(:users_unlocked_successfully)
    redirect_to users_path
  end

  def edupol_desbloquearusuario
    @user = User.find(params[:id])
    @user.failed_attempts = 0
    @user.unlock_token = nil
    @user.locked_at = nil
    @user.save(validate: false)
    flash['success'] = I18n.t(:user_unlocked_successfully)
    redirect_to root_path
  end

  def inactivaruser
    @user.activo = 'N'
    @user.save
    flash['success'] = I18n.t(:user_deactivated_successfully)
    redirect_to users_path
  end

  def activaruser
    @user.activo = 'S'
    @user.save
    flash['success'] = I18n.t(:user_activated_successfully)
    redirect_to users_path
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Usuario eliminado correctamente' }
      format.json { head :no_content }
    end
  end

  def etapa
    @user = User.find(params[:id])
    params[:etapa].to_s != "" ? User.find(params[:id]).update_columns(etapa: params[:etapa].to_s) : nil
    redirect_to root_path
  end

  def etapar
    if params[:etapar].to_s != ""
      User.where(id: is_admin).update_all(etapar: params[:etapar].to_s, updated_at: Time.now)
    end
    redirect_to root_path
  end

  def etapar2
    isadmin = is_admin
    isportafolio = is_portafolio
    isportafoliosucursal = is_portafoliossucursal
    if params[:etapa].to_s != ""
      @user = User.find(isadmin)
      @user.etapa = params[:etapa]
      @user.save(validate: false)
      # ActiveRecord::Base.connection.execute("update users set etapa = '#{params[:etapa]}' where id = #{params[:id]}")
      if params[:etapa].to_s == "A"

      elsif params[:etapa].to_s == "B"

      elsif params[:etapa].to_s == "Z"

      elsif params[:etapa].to_s == "X"

      elsif params[:etapa].to_s == "EC" # Cohorte

      elsif params[:etapa].to_s == "EE" # Cohorte por estado

      elsif params[:etapa].to_s == "EA"

      elsif params[:etapa].to_s == "EU"

      end
    end
    redirect_to reportes_path(etapa: params[:etapa], lasucursalid: params[:surcursal], vehiculonombre: params[:vehiculonombre], sucursalnombre: params[:sucursalnombre], mes: @dato1, anno: @dato2, vehiculoid: params[:vehiculoid], estado: params[:estado])
  end

  def cambioportafolio
    @user = User.find(params[:id])
    @user.portafolio_id = params[:p]
    @user.save(validate: false)
    redirect_to menus_path
  end

  def cambiotipoconsulta
    @user = User.find(params[:id])
    @user.tipoconsulta = params[:nueva]
    @user.tipoconsulta2 = params[:actual]
    @user.save(validate: false)
    redirect_to menus_path
  end

  def cambiosucursal
    @user = User.find(params[:id])
    @user.portafoliossucursal_id = params[:s]
    @user.save(validate: false)
    redirect_to menus_path
  end

  def resetpass
    @user = User.find(params[:id])
    @user.sign_in_count = 0
    @user.password = '123456789'
    @user.password_confirmation = '123456789'
    @user.save(validate: false)
    redirect_to users_path
  end

  def cambiarperfil
    @user = User.find(params[:id])
    @user.portafolioscargo_id = params[:portafolioscargo_id]
    @user.save(validate: false)
    ProcesoJob.perform_now("prc_userscargos(#{@user.id},#{params[:portafolioscargo_id]})")

    flash[:notice] = "Cargo actualizado con exito"
    redirect_to edit_user_path(:id => @user.id)
  end

  def permisosymodulos
    isportafolio = is_portafolio
    @datos = Objeto.find_by_sql(["
                      select u.id,u.identificacion, u.nombre, u.username, u.email, u.tipoconsulta, u.observaciones, decode(u.activo,'S','SI','NO') estado,
                             'MODULO' proceso, m.descripcion modulo, null permiso, null elimina, null actualiza, null crea,
                             (select descripcion from portafolioscargos where id = u.portafolioscargo_id) cargo
                      from   users u, usersmodulos um, modulos m
                      where  u.portafolio_id = #{isportafolio} and u.tipoconsulta != 'CLIENTE' AND (u.GEINTAC = 'N' OR u.GEINTAC IS NULL)
                      and    u.id = um.user_id
                      and    um.modulo_id = m.id
                      union
                      select u.id,u.identificacion, u.nombre, u.username, u.email, u.tipoconsulta, u.observaciones, decode(u.activo,'S','SI','NO') estado,
                             'PERMISO' proceso,null, m.descripcion_ampliada, decode(up.elimina,'S','SI','NO'), decode(up.actualiza,'S','SI','NO'), decode(up.crea,'S','SI','NO'),
                             (select descripcion from portafolioscargos where id = u.portafolioscargo_id) cargo
                      from   users u, userspermisos up, objetos m
                      where  u.portafolio_id = #{isportafolio} and u.tipoconsulta != 'CLIENTE' AND (u.GEINTAC = 'N' OR u.GEINTAC IS NULL)
                      and    u.id = up.user_id
                      and    up.objeto_id = m.id"])
    @datos1 = Objeto.find_by_sql(["
                      select u.id,u.identificacion, u.nombre, u.username, u.email, to_char(u.current_sign_in_at,'DD-MM-YYYY HH24:MM:SS') current_sign_in_at, u.tipoconsulta, decode(u.activo,'S','SI','NO') estado
                      from   users u
                      where  u.portafolio_id = #{isportafolio} and u.tipoconsulta != 'CLIENTE' AND (u.GEINTAC = 'N' OR u.GEINTAC IS NULL)"])
    @datos2 = Objeto.find_by_sql(["
                      select u.id,u.identificacion, u.nombre, u.username, u.email, u.tipoconsulta, to_char(i.updated_at,'DD-MM-YYYY HH24:MM:SS') fchgeneracion,
                             decode(i.metodo,'download_datacollector','download_datacollector',(select nombre from reportes where metodo = i.metodo)) nombre_informe
                      from   informes i, users u
                      where  i.portafolio_id = #{isportafolio}
                      and    i.user_id = u.id
                      and    u.portafolio_id = #{isportafolio}
                      and    u.tipoconsulta != 'CLIENTE' AND (u.GEINTAC = 'N' OR u.GEINTAC IS NULL)
                      order by u.id, i.updated_at desc"])
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Imah_Usuarios_' + "#{Time.now.strftime("%Y%m%d_%X")}" + '.xlsx"'
      }
    end
  end

  def searchall
    palabra = "%#{replacespace(params[:q])}%"
    @users = User.where("CONCAT(IFNULL(nombre,' '),' ',IFNULL(identificacion,' ')) like ?", palabra).limit(10)
    respond_to do |format|
      format.json { render json: @users.map { |p| { id: p.id, name: "#{p.nombre}" } } }
    end
  end

  def copyusers
    @user = User.find(params[:user_actual])
    if params[:user_id].to_s != ""
      if params[:user_id].to_i != @user.id
        ActiveRecord::Base.connection.execute("CALL prc_copyusers(#{@user.id},#{params[:user_id].to_i})")
      end
    end
    redirect_to edit_user_path(etapa: "A", id: @user.id)
  end

  private

  def set_layout
    if ['index', 'new', 'create', 'update'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_users'
    elsif ['inconsistencias'].include?(action_name)
      'excel'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    if params[:etapa].to_s != ""
      @user = User.find(params[:id])
      @user.etapa = params[:etapa]
      @user.save(validate: false)
    end
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit!
  end
end
