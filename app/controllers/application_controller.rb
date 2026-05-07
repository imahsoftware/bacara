class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  require 'digest'

  helper :all

  protect_from_forgery with: :exception

  before_action :authenticate_user!, except: [:validatesession]
  before_action :validatesession
  #before_action :soportespendientes, :soportespendientescant, :agendasmenus
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :allow_iframe_requests

  before_action :bloqueo_user_index

  # Verifica si el acceso del usuario PERSONA expiró y lo redirige a la pantalla de expiración.
  # Se salta a sí mismo y al AccessExpiredController para no crear un loop.
  before_action :check_access_expiration

  def validatesession
    if current_user == nil
      cookies.delete(:_session_id)
      cookies.delete(:user_id)
      cookies.delete(:username)
    end
  end

  def allow_iframe_requests
    response.headers.delete('X-Frame-Options')
  end

    helper_method :is_admin
    def is_admin
      return current_user.id rescue nil
    end

    helper_method :is_portafolioname
    def is_portafolioname
      return User.find(is_admin).portafolio.nombrecorto rescue nil
    end

   helper_method :is_usuario
   def is_usuario
     return User.find(is_admin).nombre
   end

   helper_method :quita_acento1
   def quita_acento1(dato)
     valor = dato.gsub('Á','A')
     valor = valor.gsub('É','E')
     valor = valor.gsub('Í','I')
     valor = valor.gsub('Ó','O')
     valor = valor.gsub('Ú','U')
     valor = valor.gsub('Ñ','N')
     return valor.to_s
   end

   helper_method :permiso
   def permiso(objeto, evento) #Evento debe ser A:Actualiza, E:Elimina, C:Crea
     objetoid = Objeto.find_by_descripcion(objeto)
     if objetoid.to_s != ""
       userspermisos = Userspermiso.where('user_id = ? and objeto_id = ?', is_admin, objetoid)
       userspermisos.each do |data|
         if evento == "A"
           return data.actualiza
         elsif evento == "E"
           return data.elimina
         elsif evento == "C"
           return data.crea
         end
       end
     end
   end

   helper_method :descmes
   def descmes(mes)
     if mes.to_s == '1'
       return 'ENERO'
     elsif mes.to_s == '2'
       return 'FEBRERO'
     elsif mes.to_s == '3'
       return 'MARZO'
     elsif mes.to_s == '4'
       return 'ABRIL'
     elsif mes.to_s == '5'
       return 'MAYO'
     elsif mes.to_s == '6'
       return 'JUNIO'
     elsif mes.to_s == '7'
       return 'JULIO'
     elsif mes.to_s == '8'
       return 'AGOSTO'
     elsif mes.to_s == '9'
       return 'SEPTIEMBRE'
     elsif mes.to_s == '10'
       return 'OCTUBRE'
     elsif mes.to_s == '11'
       return 'NOVIEMBRE'
     elsif mes.to_s == '12'
       return 'DICIEMBRE'
     else
       return '------'
     end
   end

   helper_method :descmesmin
   def descmesmin(mes)
     if mes.to_i == 1
       return 'Enero'
     elsif mes.to_i == 2
       return 'Febrero'
     elsif mes.to_i == 3
       return 'Marzo'
     elsif mes.to_i == 4
       return 'Abril'
     elsif mes.to_i == 5
       return 'Mayo'
     elsif mes.to_i == 6
       return 'Junio'
     elsif mes.to_i == 7
       return 'Julio'
     elsif mes.to_i == 8
       return 'Agosto'
     elsif mes.to_i == 9
       return 'Septiembre'
     elsif mes.to_i == 10
       return 'Octubre'
     elsif mes.to_i == 11
       return 'Noviembre'
     elsif mes.to_i == 12
       return 'Diciembre'
     else
       return '------'
     end
   end

   helper_method :namedate
   def namedate(fecha)
     day_names = I18n.t(:day_names_full)
     month_names = I18n.t(:month_names_full)
     dia = fecha.strftime("%w").to_i
     ndia = day_names[dia]
     mes = fecha.strftime("%m").to_i
     nmes = month_names[mes]
     fchcompleta = I18n.t(:fecha_larga_formato, dia_semana: ndia, dia: fecha.strftime("%d"), mes: nmes, anio: fecha.strftime("%Y"))
     return fchcompleta
   end

   helper_method :namedate2
   def namedate2(fecha)
     day_names = I18n.t(:day_names_lower)
     month_names = I18n.t(:month_names_lower)
     dia = fecha.strftime("%w").to_i
     ndia = day_names[dia]
     mes = fecha.strftime("%m").to_i
     nmes = month_names[mes]
     fchcompleta = I18n.t(:fecha_larga_formato, dia_semana: ndia, dia: fecha.strftime("%d"), mes: nmes, anio: fecha.strftime("%Y"))
     return fchcompleta
   end

   def helpers
     ActionController::Base.helpers
   end

  helper_method :camponumericoinforme
  def camponumericoinforme(campo)
    campo1 = campo.to_f
    if campo1 == 0
      campo1 = campo
    else
      campo1 = helpers.number_to_currency(campo, precision: 0, unit: "", delimiter: ".")
      #campo1 = number_to_currency( campo.to_i, :precision => 0, :unit=>"", :delimiter =>".")
    end
    return campo1
  end

   helper_method :replaceenter
   def replaceenter(campo)
     b = campo.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     b = b.sub("\n","<br/>")
     return b
   end
#
#   rescue_from CanCan::AccessDenied do |exception|
#    flash[:warning] = "Usted no tiene acceso a este Modulo"
#    redirect_to menus_url
#  end

  helper_method :is_host
  def is_host
    return Parametro.find(16).valor.to_s
=begin
    ip = request.env['REMOTE_ADDR'].to_s
    #logger.error("1sifiiiii conexion - #{ip2}")
    if ip == '127.0.0.1'
      @objeto = Objeto.find_by_sql("SELECT valor FROM (SELECT valor FROM sifis where descripcion = 'HOST BALANCE LOCAL'
                                    ORDER BY dbms_random.value) WHERE rownum = 1")
      @objeto.each do |objeto|
        return objeto.valor
      end
    else
      if ip[0,10] == '192.168.1.'
        @objeto = Objeto.find_by_sql("SELECT valor FROM (SELECT valor FROM sifis where descripcion = 'HOST BALANCE LOCAL'
                                      ORDER BY dbms_random.value) WHERE rownum = 1")
        @objeto.each do |objeto|
          return objeto.valor
        end
      else
        @objeto = Objeto.find_by_sql("SELECT valor FROM (SELECT valor FROM sifis where descripcion = 'HOST BALANCE'
                                      ORDER BY dbms_random.value) WHERE rownum = 1")
        @objeto.each do |objeto|
          return objeto.valor
        end
      end
    end
=end
  end

  helper_method :numero_a_palabras
  def numero_a_palabras(numero)
    de_tres_en_tres = numero.to_i.to_s.reverse.scan(/\d{1,3}/).map{|n| n.reverse.to_i}

    millones = [
      {true => nil, false => nil},
      {true => 'MILLÓN', false => 'MILLONES'},
      {true => "BILLÓN", false => "BILLONES"},
      {true => "TRILLÓN", false => "TRILLONES"}
    ]

    centena_anterior = 0
    contador = -1
    palabras = de_tres_en_tres.map do |numeros|
      contador += 1
      if contador%2 == 0
        centena_anterior = numeros
        [centena_a_palabras(numeros), millones[contador/2][numeros==1]].compact if numeros > 0
      elsif centena_anterior == 0
        [centena_a_palabras(numeros), "MIL", millones[contador/2][false]].compact if numeros > 0
      else
        [centena_a_palabras(numeros), "MIL"] if numeros > 0
      end
    end

    palabras.compact.reverse.join(' ')
  end

  helper_method :centena_a_palabras
  def centena_a_palabras(numero)
    especiales = {
      11 => 'ONCE', 12 => 'DOCE', 13 => 'TRECE', 14 => 'CATORCE', 15 => 'QUINCE',
      10 => 'DIEZ', 20 => 'VEINTE', 100 => 'CIEN'
    }
    if especiales.has_key?(numero)
      return especiales[numero]
    end

    centenas = [nil, 'CIENTO', 'DOSCIENTOS', 'TRESCIENTOS', 'CUATROCIENTOS', 'QUINIENTOS', 'SEISCIENTOS', 'SETECIENTOS', 'OCHOCIENTOS', 'NOVECIENTOS']
    decenas = [nil, 'DIECI', 'VEINTI', 'TREINTA', 'CUARENTA', 'CINCUENTA', 'SESENTA', 'SETENTA', 'OCHENTA', 'NOVENTA']
    unidades = [nil, 'UN', 'DOS', 'TRES', 'CUATRO', 'CINCO', 'SEIS', 'SIETE', 'OCHO', 'NUEVE']

    centena, decena, unidad = numero.to_s.rjust(3,'0').scan(/\d/).map{|i| i.to_i}

    palabras = []
    palabras << centenas[centena]

    if especiales.has_key?(decena*10 + unidad)
      palabras << especiales[decena*10 + unidad]
    else
      tmp = "#{decenas[decena]}#{' Y ' if decena > 2 && unidad > 0}#{unidades[unidad]}"
      palabras << (tmp.blank? ? nil : tmp)
    end
    palabras.compact.join(' ')
  end

  helper_method :is_quita_acento
  def is_quita_acento(dato)
    valor = dato.gsub('Á','A') rescue nil
    valor = valor.gsub('É','E') rescue nil
    valor = valor.gsub('Í','I') rescue nil
    valor = valor.gsub('Ó','O') rescue nil
    valor = valor.gsub('Ú','U') rescue nil
    valor = valor.gsub('Ñ','N') rescue nil
    return valor.to_s
  end

  helper_method :is_select_tiposestado
  def is_select_tiposestado
    @tiposestados = Tiposestado.where("estado = ?",'ACTIVO').order(:descripcion)
    return @tiposestados
  end

  helper_method :is_select_municipio
  def is_select_municipio
    @municipios = Municipio.where("pais = '#{is_pais}'").order('descripcion')
    return @municipios
  end

  helper_method :is_select_user
  def is_select_user
    @users = User.all.order("nombre")
    return @users
  end

  helper_method :is_select_useractivo
  def is_select_useractivo
    @users = User.where(["activo = 'S'"]).all.order("nombre")
    return @users
  end

  helper_method :is_select_tipodocumento
  def is_select_tipodocumento
    @datos = Tiposdocumento.all.order("id")
    return @datos
  end

   helper_method :facturacero
   def facturacero(campo)
     @facturas = Objeto.find_by_sql("select lpad(#{campo},8,'0') fact from dual")
     @facturas.each do |factura|
       return factura.fact
     end
   end

   helper_method :facturacero6
   def facturacero6(campo)
     @facturas = Objeto.find_by_sql("select lpad(#{campo},6,'0') fact from dual")
     @facturas.each do |factura|
       return factura.fact
     end
   end

   helper_method :replacespace
   def replacespace(campo)
    b = campo.sub(" ","%%")
    b = b.sub(" ","%%")
    b = b.sub(" ","%%")
    b = b.sub(" ","%%")
    b = b.sub(" ","%%")
    return b
   end

  helper_method :is_portafolio
  def is_portafolio
    if user_signed_in?
      return User.find(is_admin).portafolio_id
    end
  end

   helper_method :is_authport
   def is_authport(port)
      return User.exists?(["id = #{is_admin} and portafolio_id in (#{port})"]) rescue nil
   end

  helper_method :is_dash
  def is_dash
    if is_portafolio != 10100
      if User.find(is_admin).dashboard.to_s == 'NO'
        return false
      else
        return true
      end
    else
      return true
    end
  end

  helper_method :is_tipoconsulta
  def is_tipoconsulta
    return User.find(is_admin).tipoconsulta.to_s
  end

  helper_method :is_adminext
  def is_adminext
    return User.find(is_admin).extension.to_s
  end

  helper_method :is_bloqueo
  def is_bloqueo
    if User.find(is_admin).portafolio.bloqueo.to_s == 'SI'
      return true
    else
      return false
    end
  end

  helper_method :is_sygma
  def is_sygma
    if User.find(is_admin).geintac.to_s == 'S'
      return true
    else
      return false
    end
  end

  helper_method :is_supersygma
  def is_supersygma
    if User.find(is_admin).supersygma.to_s == 'YES'
      return true
    else
      return false
    end
  end

  helper_method :is_etapa
  def is_etapa
    return User.find(is_admin).etapa.to_s
  end

  helper_method :is_auth_c
  def is_auth_c(objeto)
    puts "buscanddo..." + objeto.to_s
    objetoid = Objeto.find_by_descripcion(objeto.to_s).id rescue 0
    if objetoid.to_s != '0'
      return Userspermiso.exists?(["user_id = ? and objeto_id = ? and crea = 'S'", is_admin, objetoid])
    else
      return false
    end
  end

  helper_method :is_auth_e
  def is_auth_e(objeto)
    objetoid = Objeto.find_by_descripcion(objeto.to_s).id rescue 0
    if objetoid.to_s != ""
      return Userspermiso.exists?(["user_id = ? and objeto_id = ? and elimina = 'S'", is_admin, objetoid])
    else
      return false
    end
  end

  helper_method :is_auth_a
  def is_auth_a(objeto)
    objetoid = Objeto.find_by_descripcion(objeto.to_s).id rescue 0
    if objetoid.to_s != ""
      return Userspermiso.exists?(["user_id = ? and objeto_id = ? and actualiza = 'S'", is_admin, objetoid])
    else
      return false
    end
  end

  helper_method :is_permiso
  def is_permiso(permiso)
    permisoid = Permiso.find_by_descripcion(permiso).id rescue 0
    if permisoid.to_s != ""
      return Portafoliospermiso.exists?(["portafolio_id = ? and permiso_id = ?", is_portafolio, permisoid])
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])

    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit!
    end
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit!
    end
  end

  helper_method :is_permit
  def is_permit(controlador)
    dato = '/'+controlador
    mod = Modulo.find_by(controlador: dato) rescue nil
    if Usersmodulo.where(user_id: is_admin, modulo_id: mod.id).exists?
      return true
    else
      flash[:warning] = 'Usted no tiene Acceso a este modulo'
      redirect_to root_path
    end
  end

  helper_method :is_estudiante
  def is_estudiante
    if is_tipoconsulta.to_s == 'CLIENTE'
      return true
    else
      return false
    end
  end

  helper_method :is_cliente
  def is_cliente
    return current_user.cliente_id
  end

  helper_method :is_barcode
  def is_barcode(tipo,dato,size,nombre)
    name = "#{::Rails.root}/public/codes/#{nombre.to_s}.png"
    if File.exist?(name) == false
      #@blob = Barby::GS1128.new('1','B',p.consecutivo.to_s).to_png(height: 20, margin: 5)
      #@blob2 = Barby::QrCode.new(p.consecutivo.to_s).to_png(:xdim => 2)
      if tipo.to_s == 'GS1128' and dato.to_s != "" and size.to_i > 0 and nombre.to_s != ""
        blob = Barby::GS1128.new(nil,'C',dato.to_s).to_png(:margin => 2, :height => 55)
        #blob = Barby::GS1128.new(nil,'B',dato.to_s).to_png(height: 40, width: size.to_i)
        File.open(name.to_s, 'wb') {|f| f.write blob }
      elsif tipo.to_s == 'QRCODE' and dato.to_s != "" and size.to_i > 0
        name = "#{::Rails.root}/public/qr/#{nombre.to_s}.png"
        blob = Barby::QrCode.new(dato.to_s).to_png(:xdim => size.to_i)
        File.open(name.to_s, 'wb') {|f| f.write blob }
      end
    end
  end

  helper_method :is_keymd5
  def is_keymd5(message)
    return Digest::MD5.hexdigest(message)
  end

 helper_method :is_keysha256
  def is_keysha256(message)
    return Digest::SHA256.hexdigest(message)
  end

  helper_method :is_select_actividadejecucion
  def is_select_actividadejecucion
    @objetos = Contratosactividad.where(["id in (select distinct contratosactividad_id from contratosactejecuciones)"]).order(:detalle)
    return @objetos
  end

  helper_method :is_select_sedeejecucion
  def is_select_sedeejecucion
    @objetos = Contratossede.where(["contrato_id = 97 and id in (select distinct contratossede_id from contratosactejecuciones)"]).order(:nombre)
    return @objetos
  end

  helper_method :is_select_userejecucion
  def is_select_userejecucion
    @objetos = User.where(["id in (select distinct user_id from contratosactejecuciones)"]).order(:nombre)
    return @objetos
  end

  helper_method :is_select_contratossedes
  def is_select_contratossedes
    @usr = User.find(is_admin)
    if @usr.tipoconsulta.to_s == 'METRO'
      Contratossede.where(["contrato_id = #{@usr.contrato_id}"]).order("nombre")
    else
      #Contratossede.where(["contrato_id = #{@usr.contrato_id} and estado = 'ACTIVO' and (clase_aseo = '#{@usr.clase_aseo.to_s}' or clase_aseo2 = '#{@usr.clase_aseo.to_s}' or clase_aseo3 = '#{@usr.clase_aseo.to_s}' or clase_aseo4 = '#{@usr.clase_aseo.to_s}' or clase_aseo5 = '#{@usr.clase_aseo.to_s}')"]).order("nombre")
      Contratosnodo.where(["contrato_id = #{@usr.contrato_id} and estado = 'ACTIVO' and (clase_aseo = '#{@usr.clase_aseo.to_s}' or clase_aseo2 = '#{@usr.clase_aseo.to_s}' or clase_aseo3 = '#{@usr.clase_aseo.to_s}' or clase_aseo4 = '#{@usr.clase_aseo.to_s}' or clase_aseo5 = '#{@usr.clase_aseo.to_s}')"]).order("nombre")
    end
  end

  helper_method :is_select_contratossedesmetro
  def is_select_contratossedesmetro
    Contratossede.where(["contrato_id = 97 and estado = 'ACTIVO' and id in (select distinct contratossede_id from contratosactnovedades)"]).order("nombre")
  end

  helper_method :is_select_tiposnovedades
  def is_select_tiposnovedades
    @objetos = Tiposnovedad.where(["id in (select distinct tiposnovedad_id from contratospernovedades)"]).order(:descripcion)
    return @objetos
  end

  helper_method :is_select_contratos
  def is_select_contratos
    @objetos = Contrato.joins(:empresa)
                       .select("concat(empresas.nombre,' - ',contratos.nro_contrato) datos, contratos.id")
                       .where(["(contratos.id in (select distinct contrato_id from contratosperfechas) or contratos.id in (select distinct contrato_id from contratosgrupos))"]).order("empresas.identificacion")
    return @objetos
  end

  helper_method :is_select_contratos_activos
  def is_select_contratos_activos
    @objetos = Contrato.joins(:empresa)
                       .select("concat(empresas.nombre,' - ',contratos.nro_contrato) datos, contratos.id")
                       .where(["contratos.estado not in ('LIQUIDADO','ANULADO')"]).order("empresas.identificacion")
    return @objetos
  end

  helper_method :is_select_contratos_activosbyportafolio
  def is_select_contratos_activosbyportafolio(nmPortafolio)
    @objetos = Contrato.joins(:empresa)
                       .select("concat(empresas.nombre,' - ',contratos.nro_contrato) datos, contratos.id")
                       .where(["empresas.portafolio_id = #{nmPortafolio} and contratos.estado not in ('LIQUIDADO','ANULADO') and contratos.id in (select distinct contrato_id from contratosperfechas where estado = 'ACTIVO')"]).order("empresas.identificacion")
    return @objetos
  end

  helper_method :is_select_contratos_activos_verificacion
  def is_select_contratos_activos_verificacion
    @objetos = Objeto.find_by_sql("SELECT CONCAT(e.nombre, ' - ', c.nro_contrato) AS datos, c.id
                                  FROM contratos c
                                  JOIN empresas e ON c.empresa_id = e.id
                                  WHERE c.estado NOT IN ('LIQUIDADO', 'ANULADO')
                                    AND c.id IN (
                                      SELECT cp.contrato_id
                                      FROM contratosperfechas cp
                                      WHERE cp.estado = 'ACTIVO'
                                    )
                                    AND NOT EXISTS (
                                      SELECT 1
                                      FROM veriservicios vs
                                      WHERE vs.contrato_id = c.id
                                        AND vs.estado_proceso IN ('EN PROCESO', 'PENDIENTE')
                                    )
                                  ORDER BY e.identificacion")

    return @objetos
  end

  helper_method :is_select_procesos
  def is_select_procesos
    @objetos = Iparametro.where(campo: 'proceso').order(:descripcion).order("descripcion")
    return @objetos
  end

  helper_method :is_select_contratossol
  def is_select_contratossol
    @objetos = Contrato.joins(:empresa)
                       .select("concat(empresas.nombre,' - ',contratos.nro_contrato) datos, contratos.id")
                       .where(["contratos.id in (select distinct contrato_id from contratossolicitudes)"]).order("empresas.identificacion")
    return @objetos
  end

  helper_method :is_select_eproveedoregresos
  def is_select_eproveedoregresos
    @objetos = Eproveedor.select("autobuscar datos, id")
                       .where(["id in (select distinct eproveedor_id from egresos)"]).order("identificacion")
    return @objetos
  end

  helper_method :is_select_eproveedorcausacion
  def is_select_eproveedorcausacion
    @objetos = Eproveedor.select("autobuscar datos, id")
                         .where(["id in (select distinct eproveedor_id from eproveedorescompras)"]).order("identificacion")
    return @objetos
  end

  helper_method :is_dashboard
  def is_dashboard
    if is_sygma
      return true
    else
      isportafolio = is_portafolio
      por = Portafolio.find(isportafolio)
      if por.act_dash.to_s == 'SI'
        return true
      else
        return false
      end
    end
  end

  helper_method :is_persona
  def is_persona
    if current_user.tipoconsulta.to_s == 'PERSONA'
      return true
    else
      return false
    end
  end

  helper_method :is_select_periodosliquidaciones
  def is_select_periodosliquidaciones(vcTermino)
    @objetos = Periodosliquidacion.where(["estado = 'P' and inicio <= date_add(now(),INTERVAL 15 DAY) and termino = '#{vcTermino}'"]).order("inicio asc").all
    return @objetos
  end

  helper_method :is_select_periodosliq
  def is_select_periodosliq
    @objetos = Periodosliquidacion.where(["estado = 'P' and inicio <= date_add(now(),INTERVAL 15 DAY)"]).order("inicio asc").all
    return @objetos
  end

  helper_method :is_select_periodosliqvis
  def is_select_periodosliqvis
    @objetos = Periodosliquidacion.where(["inicio >= '2021-07-01'"]).order("inicio asc").all
    return @objetos
  end

  helper_method :is_select_periodosliqmanual
  def is_select_periodosliqmanual
    @objetos = Periodosliquidacion.where(["inicio >= date_add(now(),INTERVAL -400 DAY) and inicio <= curdate()"]).order("inicio asc").all
    return @objetos
  end

  helper_method :is_select_contratosgrupos
  def is_select_contratosgrupos(contratosId)
    @objetos = Contratosgrupo.where(["contrato_id = #{contratosId}"]).order("id asc").all
    return @objetos
  end

  helper_method :is_ambito
  def is_ambito
    return User.find(is_admin).ambito rescue nil
  end

  helper_method :is_personaid
  def is_personaid
    return User.find(is_admin).persona_id rescue nil
  end

  helper_method :is_personaadmin
  def is_personaadmin
    return User.find(is_admin).persona.administrativo rescue nil
  end

  helper_method :is_fechaperiodo
  def is_fechaperiodo(fechainicial, dias)
    fch = Objeto.find_by_sql("select ADDDATE('#{fechainicial}', INTERVAL #{dias} MONTH) fch from dual")[0].fch.to_date #.strftime("%Y-%m")
    return fch.strftime("%Y-%m").to_s
  end

  helper_method :is_dayofweek
  def is_dayofweek
    dato = Objeto.find_by_sql("SELECT UPPER((ELT(WEEKDAY(CURDATE()) + 1, 'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo'))) AS dia")[0].dia.to_s
    return dato
  end

  helper_method :is_select_portafolioscuenta
  def is_select_portafolioscuenta
    @objetos = Portafolioscuenta.where(portafolio_id: is_portafolio).order(:cod_cuenta)
    return @objetos
  end

  helper_method :is_select_portafolios
  def is_select_portafolios
    @objetos = Portafolio.all
    return @objetos
  end

  helper_method :is_consecutivolote
  def is_consecutivolote
    consec1 = Objeto.find_by_sql("SELECT max(consecutivo) consecutivo from solicitudesretiros")[0].consecutivo.to_i rescue 0
    consec2 = Objeto.find_by_sql("SELECT max(consecutivo) consecutivo from solicitudesretiros where estado_final is null")[0].consecutivo.to_i rescue 0
    if consec2 > 0
      return consec2
    elsif consec1 > 0
      return consec1 + 1
    else
      return 1
    end
  end

  helper_method :is_consecutivoservicio
  def is_consecutivoservicio
    dato = Consecutivo.create!
    return dato.id
  end

  helper_method :is_consecutivovaca
  def is_consecutivovaca
    consec1 = Objeto.find_by_sql("SELECT max(consecutivo) consecutivo from contratospervacaciones where estado = 'LIQUIDADA'")[0].consecutivo.to_i rescue 0
    if consec1 > 0
      return consec1
    else
      consec2 = Objeto.find_by_sql("SELECT max(consecutivo) consecutivo from contratospervacaciones where estado = 'PAGADA'")[0].consecutivo.to_i rescue 0
      if consec2 > 0
        return consec2 + 1
      end
    end
  end

  helper_method :is_camponumerico
  def is_camponumerico(valor)
    number_to_currency(valor, precision: 2, unit: "", delimiter: ".")
  end

  helper_method :is_egresoactual
  def is_egresoactual(isportafolio)
    nro = Egreso.select("IFNULL(MAX(nro_egreso) ,0) nro").where(["portafolio_id = #{isportafolio}"])[0].nro.to_i rescue 0
    return nro.to_i
  end

  # Persona: tras login, ir a baccarat (jugada PENDIENTE) o al listado de sus jugadas
  def after_sign_in_path_for(user)
    if user.tipoconsulta.to_s == 'PERSONA'
      pend = Jugada.primera_pendiente_para(user)
      return new_jugadasdetalle_path(jugada_id: pend.to_param) if pend
      return jugadas_path
    end
    super
  end

  private

  def bloqueo_user_index
    return unless current_user
    if current_user.bloqueo == 'SI'
      #puts "Fabian... #{request.path.to_s rescue nil}"
      if ['/tareas/gestion','/'].exclude?(request.path)
        flash[:alert] = I18n.t(:cannot_access_until_process_finishes)
        redirect_to root_path
      end
    end
  end

  def check_access_expiration
    return unless current_user
    return unless current_user.access_expired?
    # Evitar loop en destroy
    return if controller_name == 'sessions' && action_name == 'destroy'
    # Cerrar sesión y redirigir al login con mensaje de error
    sign_out current_user
    flash[:alert] = I18n.t(:access_expired_login_blocked)
    redirect_to new_user_session_path
  end
end
