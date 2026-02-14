module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end

  def select_tipo_genero(params)
    if params == 'MASCULINO'
      'pantalon_hombre'
    elsif params == 'FEMENINO'
      'pantalon_mujer'
    end
  end

  def select_tipo_genero_camisa(params)
    if params == 'MASCULINO'
      'camisa_hombre'
    elsif params == 'FEMENINO'
      'camisa_mujer'
    end
  end



  def irregular_types(type)
    case type
    when 'alert'
      'danger'
    when 'notice'
      'warning'
    else
      type
    end
  end

  def select_tipoingreso
    [
      ['PROPIO', 'PROPIO'],
      ['TERCERO', 'TERCERO']
    ]
  end

  def select_diassemana
    [
      ['LUNES', 'LUNES'],
      ['MARTES', 'MARTES'],
      ['MIÉRCOLES', 'MIERCOLES'],
      ['JUEVES', 'JUEVES'],
      ['VIERNES', 'VIERNES'],
      ['SÁBADO', 'SABADO'],
      ['DOMINGO', 'DOMINGO']
    ]
  end

  def select_act_clase
    [
      ['ASEO NORMAL', 'ASEO NORMAL'],
      ['ASEO FUERTE', 'ASEO FUERTE']
    ]
  end

  def select_act_tipo
    [
      ['TRANVIA', 'TRANVIA'],
      ['ESTACION', 'ESTACION'],
      ['METROPLUS', 'METROPLUS'],
      ['PLAZOLETA', 'PLAZOLETA'],
      ['CABLE', 'CABLE'],
      ['GARAJES', 'GARAJES']
    ]
  end

  def select_act_item
    [["TECHOS", "TECHOS"], ["VIDRIOS", "VIDRIOS"], ["PISOS", "PISOS"], ["SERVICIO", "SERVICIO"], ["ESTRUCTURA LATERAL", "ESTRUCTURA LATERAL"]]
  end

  def select_clasee
    [
      ['SERVICIO', 'SERVICIO'],
      ['PERSONAL', 'PERSONAL']
    ]
  end

  def select_act_calificacion
    [
      ['BUENO', 'BUENO'],
      ['REGULAR', 'REGULAR'],
      ['MALO', 'MALO']
    ]
  end

  def select_claseicetexestados
    [
      ['ICETEX', 'ICETEX'],
      ['EDUPOL', 'EDUPOL']
    ]
  end

  def select_ambitogps
    [
      ['GPS', 'GPS'],
      ['AGENCIA', 'AGENCIA'],
      ['AGENCIA JURIDICA', 'AGENCIA JURIDICA'],
      ['ESTUDIO', 'ESTUDIO']
    ]
  end

  def select_tipoedupol
    [
      ['ANTIGUOS', 'ANTIGUOS'],
      ['NUEVOS', 'NUEVOS']
    ]
  end

  def select_tipometodourl
    [
      ['GET', 'GET'],
      ['POST', 'POST']
    ]
  end

  def select_resultado
    [
      ['POSITIVO', 'POSITIVO'],
      ['NEGATIVO', 'NEGATIVO']
    ]
  end

  def select_tipoprogramaedupol
    [
      ['TECNICA PROFESIONAL', 'TECNICA PROFESIONAL'],
      ['TECNOLOGÍA', 'TECNOLOGIA'],
      ['PROFESIONAL', 'PROFESIONAL'],
      ['CURSOS ESPECIALES', 'CURSOS ESPECIALES'],
      ['ESPECIALIZACIÓN', 'ESPECIALIZACION'],
      ['MAESTRÍA', 'MAESTRIA'],
      ['DIPLOMADOS', 'DIPLOMADOS']
    ]
  end

  def metodospago(metodo)
    case metodo
    when 'CREDIT_CARD'
      'Tarjeta de Crédito'
    when 'PSE'
      'PSE'
    when 'ACH'
      'Tarjeta Débito'
    when 'CASH'
      'Efectivo'
    when 'REFERENCED'
      'Pago Referenciado'
    when 'BANK_REFERENCED'
      'Pago en Banco'
    end
  end

  def select_portafolios
    return is_select_portafolios
  end

  def select_tipocode
    [
      ['VISTA', 'VISTA'],
      ['CONTROLADOR', 'CONTROLADOR'],
      ['MODELO', 'MODELO']
    ]
  end

  def calcular_porcentaje(value1, value2)
    val = value2.to_f / value1.to_f
    porcentaje = val.to_f * 100
    return porcentaje
  end

  def calcular_restante(value1, value2)
    val = value1.to_f - value2.to_f
    return val
  end

  def log_actions(value)
    if value == 'destroy'
      "Eliminar"
    elsif value == 'create'
      "Crear"
    elsif value == 'update'
      "Actualizar"
    end
  end

  def select_sino
    [
      ["SI", "SI"],
      ["NO", "NO"]
    ]
  end

  def select_tipotraslado
    [
      ["DEFINITIVO", "DEFINITIVO"],
      ["ESTABILIDAD LABORAL", "ESTABILIDAD"],
      ["CONTINUIDAD", "CONTINUIDAD"],
      ["CENTRO DE TRABAJO Y CARGO", "CENTROCARGO"]
    ]
  end

  def select_clase_visita
    datos = []
    datos << ["SEGUIMIENTO", "SEGUIMIENTO"]
    datos << ["REUNION", "REUNION"]
    datos << ["SERVICIO ESPECIAL", "SERVICIO ESPECIAL"]
    Userspermiso.where("user_id = #{is_admin} and objeto_id = 150").each do |a|
      datos << ["TELETRABAJO", "TELETRABAJO"]
    end
    Userspermiso.where("user_id = #{is_admin} and objeto_id = 151").each do |a|
      datos << ["BRIGADA DE ASEO", "BRIGADA DE ASEO"]
    end
    return datos
  end

  def select_zapatos
    [
      ["PUNTERAS", "PUNTERAS"],
      ["DIALECTRICA", "DIALECTRICA"],
      ["SIN PUNTERA", "SIN PUNTERA"],
      ["PLASTICA", "PLASTICA"],
      ["NO APLICA", "NO APLICA"]
    ]
  end

  def select_clasevalor
    [
      ["VALOR1", "VALOR1"],
      ["VALOR2", "VALOR2"]
    ]
  end

  def select_sinoingles
    [
      ["YES", "YES"],
      ["NO", "NO"]
    ]
  end

  def select_no
    [
      ["NO", "NO"]
    ]
  end

  def select_genero
    [
      ["MASCULINO", "MASCULINO"],
      ["FEMENINO", "FEMENINO"]
    ]
  end

  def select_situacion_econo
    [
      ["EMPLEADO", "EMPLEADO"],
      ["INDEPENDIENTE", "INDEPENDIENTE"],
      ["DESEMPLEADO", "DESEMPLEADO"],
      ["PENSIONADO", "PENSIONADO"],
      ["SIN DATO", "SIN DATO"]
    ]
  end

  def select_tiposatencion
    [
      ["PERSONALIZADA", "PERSONALIZADA"],
      ["TELEFONICA", "TELEFONICA"],
      ["DOMICILIARIA", "DOMICILIARIA"],
      ["CORREO FISICO", "CORREO FISICO"],
      ["CORREO ELECTRONICO", "CORREO ELECTRONICO"],
      ["OTRA", "OTRA"]
    ]
  end

  def select_tipogecasr
    [
      ["PERSONALIZADA", "PERSONALIZADA"],
      ["TELEFONICA", "TELEFONICA"],
      ["DOMICILIARIA", "DOMICILIARIA"],
      ["CORREO FISICO", "CORREO FISICO"],
      ["CORREO ELECTRONICO", "CORREO ELECTRONICO"],
      ["PROMESA PAGO", "PROMESA PAGO"],
      ["OTRA", "OTRA"]
    ]
  end

  def select_oficinaregistro
    return is_select_oficinaregistro
  end

  def select_municipio
    return is_select_municipio
  end

  def select_notaria
    return is_select_notaria
  end

  def select_user
    return is_select_user
  end

  def select_useractivo
    return is_select_useractivo
  end

  def select_useredupol
    return is_select_useredupol
  end

  def select_parorigenespago
    return is_select_parorigenespago
  end

  def select_tipodocumento
    return is_select_tipodocumento
  end

  def select_tipopersona
    [
      ["PERSONA NATURAL", "PERSONA NATURAL"],
      ["PERSONA JURIDICA", "PERSONA JURIDICA"]
    ]
  end

  def select_estadocivil
    [
      ["CASADO", "CASADO"],
      ["DIVORCIADO", "DIVORCIADO"],
      ["ND", "ND"],
      ["Q.E.P.D.", "Q.E.P.D."],
      ["SEPARADO", "SEPARADO"],
      ["SOLTERO", "SOLTERO"],
      ["UNION LIBRE", "UNION LIBRE"],
      ["VIUDO", "VIUDO"]
    ]
  end

  def select_entidad
    [
      ["BANCOLOMBIA", "BANCOLOMBIA"],
      ["BBVA", "BBVA"],
      ["CITIBANK", "CITIBANK"],
      ["DAVIVIENDA", "DAVIVIENDA"],
      ["FCPII", "FCPII"],
      ["BANCO CAJA SOCIAL", "BANCO CAJA SOCIAL"],
      ["BANCO AGRARIO", "BANCO AGRARIO"],
      ["BANCO COLPATRIA", "BANCO COLPATRIA"],
      ["CONFIAR", "CONFIAR"],
      ["BANCO DE OCCIDENTE", "BANCO DE OCCIDENTE"],
      ["FIDUCENTRAL", "FIDUCENTRAL"]
    ]
  end

  def select_sinocorto
    [
      ["SI", "S"],
      ["NO", "N"]
    ]
  end

  def select_sn_users
    [
      ["SI", "S"],
      ["NO", "N"]
    ]
  end

  def select_codigocentro
    [
      ["1", "1"],
      ["2", "2"],
      ["3", "3"],
      ["4", "4"],
      ["5", "5"]
    ]
  end

  def select_tipoconsulta
    [
      ["SUPERVISOR", "SUPERVISOR"],
      ["SUPERNUMERARIO", "SUPERNUMERARIO"],
      ["ADMINISTRADOR", "ADMINISTRADOR"],
      ["GESTION", "GESTION"],
      ["PERSONA", "PERSONA"],
      ["CONTRATO", "CONTRATO"],
      ["METRO", "METRO"],
      ["ESTUDIANTE", "ESTUDIANTE"],
      ["CANDIDATO", "CANDIDATO"],
      ["RECTOR", "RECTOR"],
      ["TODO", "TODO"]
    ]
  end

  def select_estado
    [
      ["ACTIVO", "ACTIVO"],
      ["INACTIVO", "INACTIVO"]
    ]
  end

  def select_tipo_soporte
    [
      ["DESARROLLO NUEVO", "DESARROLLO NUEVO"],
      ["SOLICITUD SOPORTE", "SOLICITUD SOPORTE"]
    ]
  end

  def select_tipo_capacitaciondocs
    [
      ["DOCUMENTO", "DOCUMENTO"],
      ["VIDEO", "VIDEO"],
      ["LINK", "LINK"]
    ]
  end

  def select_estado_tarea
    [
      ["PENDIENTE", "0"],
      ["COMPLETO", "1"]
    ]
  end

  def select_debcre
    [
      ["DEBITO", "DEBITO"],
      ["CREDITO", "CREDITO"]
    ]
  end

  def select_estadoperiodos
    [
      ["PENDIENTE", "P"],
      ["CONSOLIDADO", "C"]
    ]
  end

  def select_estadoinsumo
    [
      ["ACTIVO", "ACTIVO"],
      ["INACTIVO", "INACTIVO"],
      ["PENDIENTE", "PENDIENTE"]
    ]
  end

  def select_estado_ac
    [
      ["ACTIVO", "ACTIVO"],
      ["INACTIVO", "INACTIVO"]
    ]
  end

  def select_categoria_documentos
    [
      ["SOCIOECONÓMICOS", "SOCIOECONÓMICOS"],
      ["ACADÉMICOS", "ACADÉMICOS"],
      ["FINANCIEROS", "FINANCIEROS"]
    ]
  end

  def select_estado_portafolios
    [
      ["ACTIVO", "ACTIVO"],
      ["INACTIVO", "INACTIVO"]
    ]
  end

  def select_estadoestudiante2
    [
      ["ACTIVO", "ACTIVO"],
      ["INACTIVO", "INACTIVO"]
    ]
  end

  def select_mes
    [
      ["ENERO", '01'],
      ["FEBRERO", '02'],
      ["MARZO", '03'],
      ["ABRIL", '04'],
      ["MAYO", '05'],
      ["JUNIO", '06'],
      ["JULIO", '07'],
      ["AGOSTO", '08'],
      ["SEPTIEMBRE", '09'],
      ["OCTUBRE", '10'],
      ["NOVIEMBRE", '11'],
      ["DICIEMBRE", '12']
    ]
  end

  def select_anno
    [
      ["2012", "2012"],
      ["2013", "2013"],
      ["2014", "2014"],
      ["2015", "2015"],
      ["2016", "2016"],
      ["2017", "2017"],
      ["2018", "2018"],
      ["2019", "2019"],
      ["2020", "2020"],
      ["2021", "2021"],
      ["2022", "2022"],
      ["2023", "2023"],
      ["2024", "2024"],
      ["2025", "2025"],
      ["2026", "2026"]
    ]
  end

  def select_mesedu
    [
      ["DICIEMBRE", '12']
    ]
  end

  def select_annoedu
    [
      ["2018", "2018"]
    ]
  end

  def select_anno2
    [
      ["2016", "2016"],
      ["2017", "2017"],
      ["2018", "2018"],
      ["2019", "2019"],
      ["2020", "2020"],
      ["2021", "2021"],
      ["2022", "2022"],
      ["2023", "2023"],
      ["2024", "2024"],
      ["2025", "2025"],
      ["2026", "2026"]
    ]
  end

  def select_anno4
    [
      ["2021", "2021"],
      ["2022", "2022"],
      ["2023", "2023"],
      ["2024", "2024"],
      ["2025", "2025"],
      ["2026", "2026"]
    ]
  end

  def select_estado_veriservicios
    [
      ["PENDIENTE", "PENDIENTE"],
      ["EN PROCESO", "EN PROCESO"],
      ["FINALIZADO", "FINALIZADO"]
    ]
  end

  def select_anno_certificado
    annos = []
    [
      Contratosperactob.select("anno").distinct.order("anno asc").each do |contratosperactob|
        annos << ["#{contratosperactob.anno}", "#{contratosperactob.anno}"]
      end
    ]
    return annos
  end

  def select_mes_certificado
    meses = []
    [
      Contratosperactob.select("mes").distinct.order("mes asc").each do |contratosperactob|
        meses << ["#{descmesmin(contratosperactob.mes)}", "#{contratosperactob.mes}"]
      end
    ]
    return meses
  end



  def select_annorenta
    [
      ["2013", "2013"],
      ["2014", "2014"],
      ["2015", "2015"],
      ["2016", "2016"],
      ["2017", "2017"],
      ["2018", "2018"]
    ]
  end

  def select_anno3
    [
      ["2013", "2013"],
      ["2014", "2014"],
      ["2015", "2015"],
      ["2016", "2016"],
      ["2017", "2017"],
      ["2018", "2018"],
      ["2019", "2019"]
    ]
  end

  def select_nivel
    [
      ["GESTION", 1],
      ["CARGUES", 6],
      ["PROCESOS", 2],
      ["PARAMETRIZACIÓN", 3],
      ["SEGURIDAD", 4],
      ["PARAMETRIZACIÓN EDUCACIÓN", 5]
    ]
  end

  def select_prioridad
    [
      ["EXTREMO", "EXTREMO"],
      ["ALTA", "ALTA"],
      ["MEDIA", "MEDIA"],
      ["BAJA", "BAJA"]
    ]
  end

  def select_formato
    [
      ["PDF", "PDF"],
      ["EXCEL", "EXCEL"]
    ]
  end

  def select_calificacion_soporte2
    [
      ['3', 3],
      ['2', 2],
      ['1', 1]
    ]
  end

  def select_niveleducativo
    [
      ["TECNICO", "TECNICO"],
      ["TECNOLOGICO", "TECNOLOGICO"],
      ["UNIVERSITARIO", "UNIVERSITARIO"],
      ["POSGRADO", "POSGRADO"]
    ]
  end

  def select_periodicidad
    [
      ["SEMESTRAL", "SEMESTRAL"],
      ["ANUAL", "ANUAL"]
    ]
  end

  def select_rangocalendar
    [2017, 2018]
  end

  def select_formapagohelena
    [
      ["EFECTIVO", "EFECTIVO"],
      ["CONSIGNACION", "CONSIGNACION"]
    ]
  end

  def select_tiposgestion
    [
      ['COBRANZA', 'COBRANZA'],
      ['VIRTUAL', 'VIRTUAL']
    ]
  end

  def active_class(link_path)
    current_page?(link_path) ? "active" : ""
  end

  def camponumerico(valor)
    number_to_currency(valor, precision: 2, unit: "", delimiter: ".")
  end

  def camponumerico2(valor)
    number_to_currency(valor, precision: 0, unit: "", delimiter: ".")
  end

  def camponumerico3(valor)
    number_to_currency(valor, precision: 3, unit: "", delimiter: ".")
  end

  def camponumerico4(valor)
    number_to_currency(valor, precision: 1, unit: "", delimiter: ".")
  end

  def select_perumunicipio
    return is_select_perumunicipio
  end

  def select_sedes
    return is_select_sedes
  end

  def select_horas
    [
      ["1 HORA", 1],
      ["2 HORAS", 2]
    ]
  end

  def select_estadocontrato
    [
      ["PERFECCIONADO", "PERFECCIONADO"],
      ["EN EJECUCION", "EN EJECUCION"],
      ["EN LIQUIDACION", "EN LIQUIDACION"],
      ["LIQUIDADO", "LIQUIDADO"],
      ["ANULADO", "ANULADO"],
      ["TERMINADO", "TERMINADO"]
    ]
  end

  def select_tipovalidacion
    [
      ["RESTRICCION", "RESTRICCION"],
      ["NOTIFICACION", "NOTIFICACION"]
    ]
  end

  def select_tipomodificacion
    [
      ["PLAZO", "PLAZO"],
      ["PLAZO - VALOR", "PLAZO - VALOR"],
      ["PLAZO - CLAUSULAS", "PLAZO - CLAUSULAS"],
      ["PLAZO - VALOR - CLAUSULAS", "PLAZO - VALOR - CLAUSULAS"],
      ["VALOR", "VALOR"],
      ["VALOR - CLAUSULAS", "VALOR - CLAUSULAS"],
      ["CLAUSULAS", "CLAUSULAS"]
    ]
  end

  def select_tipoinsumo
    [
      ["CONSUMO", "CONSUMO"],
      ["ELEMENTOS, EQUIPOS Y MAQUINARIA", "ELEMENTOS, EQUIPOS Y MAQUINARIA"]
    ]
  end

  def select_claseinsumo
    [
      ["COLOMBIA COMPRA EFICIENTE", "COLOMBIA COMPRA EFICIENTE"],
      ["GENERAL", "GENERAL"]
    ]
  end

  def select_disponibilidad
    [
      ["TIEMPO COMPLETO", "TIEMPO COMPLETO"],
      ["MEDIO TIEMPO", "MEDIO TIEMPO"]
    ]
  end

  def select_tipointerventor
    [
      ["SUPERVISOR", "SUPERVISOR"],
      ["COORDINADOR", "COORDINADOR"],
      ["INTERVENTOR", "INTERVENTOR"]
    ]
  end

  def select_claseimagen
    [
      ["CONTRATO", "CONTRATO"],
      ["PROVEEDOR", "PROVEEDOR"]
    ]
  end

  def select_estadoexamen
    [
      ["APROBADO", "APROBADO"],
      ["PENDIENTE", "PENDIENTE"],
      ["RECHAZADO", "RECHAZADO"],
      ["APLAZADO", "APLAZADO"]
    ]
  end

  def select_iva_1
    [
      ["0 %", 0.00],
      ["2.4 %", 2.40],
      ["5 %", 5.00],
      ["16 %", 16.00],
      ["19 %", 19.00],
      ["Iva sobre utilidad", -1.00]
    ]
  end

  def select_tipoproducto
    [
      ["PERSONAL", '11020'],
      ["INSUMOS", '11021'],
      ["MAQUINARIA", '11022'],
      ["OTROS", '11023'],
      ["BASE G", '11024']
    ]
  end

  def select_embargo
    [
      ["EMBARGO", "EMBARGO"],
      ["LIBRANZA", "LIBRANZA"]
    ]
  end

  def select_terminodescuento
    [
      ["QUINCENAL", "QUINCENAL"],
      ["MENSUAL", "MENSUAL"]
    ]
  end

  def select_periodosliquidaciones(vcTermino)
    return is_select_periodosliquidaciones(vcTermino)
  end

  def select_periodosliq
    return is_select_periodosliq
  end

  def select_periodosliqvis
    return is_select_periodosliqvis
  end

  def select_periodosliqmanual
    return is_select_periodosliqmanual
  end

  def select_contratos
    return is_select_contratos
  end

  def select_contratos_activos
    return is_select_contratos_activos
  end

  def select_contratos_activosbyportafolio(nmPortafolio)
    return is_select_contratos_activosbyportafolio(nmPortafolio)
  end

  def detalle_contrato(contrato)
    "#{Contrato.find(contrato).empresa.nombre} -  #{Contrato.find(contrato).nro_contrato.to_s}" rescue nil
  end

  def select_procesos
    return is_select_procesos
  end

  def select_contratossol
    return is_select_contratossol
  end

  def select_eproveedoregresos
    return is_select_eproveedoregresos
  end

  def select_eproveedorcausacion
    return is_select_eproveedorcausacion
  end

  def select_contratosgrupos(contratoId)
    return is_select_contratosgrupos(contratoId)
  end

  def select_tiponovedad
    [
      ["DEVENGO", "DEVENGO"],
      ["DEDUCCION", "DEDUCCION"],
      ["OTROS DEVENGO", "OTROS DEVENGO"]
    ]
  end

  def select_actividadejecucion
    return is_select_actividadejecucion
  end

  def select_sedeejecucion
    return is_select_sedeejecucion
  end

  def select_userejecucion
    return is_select_userejecucion
  end

  def select_contratossedes
    return is_select_contratossedes
  end

  def select_contratossedesmetro
    return is_select_contratossedesmetro
  end

  def select_tiposnovedades
    return is_select_tiposnovedades
  end

  def select_claseproceso
    [
      ["ASIGNAR", "ASIGNAR"],
      ["QUITAR", "QUITAR"]
    ]
  end

  def user_avatar_perfil(params)
    if params.avatar.present?
      image_tag params.avatar.url(:original), alt: "User profile picture", class: "profile-user-img img-responsive", height: '100', width: '100'
    else
      image_tag 'no_foto.png', class: "profile-user-img img-responsive", height: '100', width: '100'
    end
  end

  def select_riesgo
    [
      ["Riesgo I (0.00522) - Act-Eco: 1691001 ", '0.0052'], # 00522
      ["Riesgo II (0.01044) - Act-Eco: 2811001", '0.0104'], # 01044
      ["Riesgo III (0.02436) - Act-Eco: 3861001", '0.0243'], # 02436
      ["Riesgo IV (0.04350) - Act-Eco: 4492301", '0.0435'], # 04350
      ["Riesgo V (0.06960) - Act-Eco: 5812901", '0.0696'] # 06960
    ]
  end

  def select_logo
    [
      ["SEMINARIO", "logo_inicio_bacara.png"]
    ]
  end

  def select_diasdisfrute
    [
      [8, 8],
      [9, 9],
      [10, 10],
      [11, 11],
      [12, 12],
      [13, 13],
      [14, 14],
      [15, 15]
    ]
  end

  def select_jornada
    [
      ["LUNES-SABADO", "LUNES-SABADO"],
      ["LUNES-VIERNES", "LUNES-VIERNES"],
      ["LUNES-DOMINGO", "LUNES-DOMINGO"]
    ]
  end

  def select_proveedor
    [
      ["RÉGIMEN COMÚN", "RÉGIMEN COMÚN"],
      ["RÉGIMEN SIMPLIFICADO", "RÉGIMEN SIMPLIFICADO"],
      ["GRAN CONTRIBUYENTE", "GRAN CONTRIBUYENTE"]
    ]
  end

  def select_formapago
    [
      ["EFECTIVO", "EFECTIVO"],
      ["CONSIGNACION", "CONSIGNACION"],
      ["TRANSFERENCIA", "TRANSFERENCIA"],
      ["CHEQUE", "CHEQUE"]
    ]
  end

  def select_campo
    iparametros_campos = Iparametro.distinct.pluck(:campo)
    opciones = iparametros_campos.map { |campo| [campo, campo] }

    opciones += [
      ["arl","arl"],
      ["banco","banco"],
      ["caja_compensacion","caja_compensacion"],
      ["cargo","cargo"],
      ["documentos_contratacion","documentos_contratacion"],
      ["documentos_personales","documentos_personales"],
      ["documentos_post-contratacion","documentos_post-contratacion"],
      ["epp","epp"],
      ["eps","eps"],
      ["estado_civil","estado_civil"],
      ["estrato","estrato"],
      ["fondo_pension","fondo_pension"],
      ["genero","genero"],
      ["grupo_nomina","grupo_nomina"],
      ["nivel_educacion","nivel_educacion"],
      ["parentesco","parentesco"],
      ["proceso","proceso"],
      ["situacion_especial","situacion_especial"],
      ["tipo_contrato","tipo_contrato"],
      ["tipo_cuenta","tipo_cuenta"],
      ["tipo_identificacion","tipo_identificacion"],
      ["tipo_identificacion_proveedor","tipo_identificacion_proveedor"]
    ]

    opciones
  end

  def select_campo_asignado
    array = []
    Usersparametro.where("user_id = #{is_admin}").each do |parametro|
      array << [parametro.campo.to_s, parametro.campo.to_s]
    end
    return array
  end


  def select_clase
    [
      ["CONTRATO", "CONTRATO"],
      ["PROVEEDOR", "PROVEEDOR"]
    ]
  end

  def select_iva
    [
      ["0 %", 0],
      ["5 %", 5],
      ["19 %", 19]
    ]
  end

  def select_monedapayu
    [
      ['Peso Argentino', 'ARS'],
      ['Real Brasileño', 'BRL'],
      ['Peso Chileno', 'CLP'],
      ['Peso Colombiano', 'COP'],
      ['Peso Mexicano', 'MXN'],
      ['Nuevo Sol Peruano', 'PEN'],
      ['Dólar Americano', 'USD']
    ]
  end

  # Descripcion: Metodo - Url de token aportes en linea
  # Fecha Creacion: 20-Julio-2022
  # Autor: AFP
  def select_url_aportes
    [
      ['PRUEBA', 'https://marketplacepruebas.aportesenlinea.com/Transversales.Servicios.Fachada/api/ControlAcceso/Autenticar'],
      ['PRODUCCION', 'https://marketplace.aportesenlinea.com/Transversales.Servicios.Fachada/api/ControlAcceso/Autenticar']
    ]
  end

  # Descripcion: Metodo - Url de crear cotizante
  # Fecha Creacion: 20-Julio-2022
  # Autor: AFP
  def select_url_aportes_cotizante
    [
      ['PRUEBA', 'https://marketplacepruebas.aportesenlinea.com/Fanaia.Servicios.Fachada/api/Cotizantes/CrearCotizante'],
      ['PRODUCCION', 'https://marketplace.aportesenlinea.com/Fanaia.Servicios.Fachada/api/Cotizantes/ConsultarCotizantes']
    ]
  end

  # Descripcion: Metodo - Url de cetificado de aportes
  # Fecha Creacion: 20-Julio-2022
  # Autor: AFP
  def select_url_aportes_certificado
    [
      ['PRUEBA', 'https://aplicacionespruebas.aportesenlinea.com/Reportes.ServicioWeb/Reportes.svc/CertificadoAportes'],
      ['PRODUCCION', 'https://aplicaciones.aportesenlinea.com/Reportes.ServicioWeb/Reportes.svc/CertificadoAportes']
    ]
  end

  # Descripcion: Metodo - Url de creacion de novedades
  # Fecha Creacion: 25-Agosto-2022
  # Autor: AFP
  def select_url_aportes_novedades
    [
      ['PRUEBA', 'https://marketplace.aportesenlinea.com/Fanaia.Servicios.Fachada/api/NovedadesRefactor/CrearNovedades'],
      ['PRODUCCION', 'https://marketplace.aportesenlinea.com/Fanaia.Servicios.Fachada/api/NovedadesRefactor/CrearNovedades']
    ]
  end

  # Descripcion: Metodo - Id para aplicacion Aportes en linea
  # Fecha Creacion: 20-Julio-2022
  # Autor: AFP
  def select_aplicacion_aportes
    [
      ['PRUEBA', 'E2271FA7-0FCA-4293-BF6D-53414286FDB0'],
      ['PRODUCCION', 'FBC3E3BA-C0CA-4110-9EC5-FFA0C0E629F0']
    ]
  end

  # Descripcion: Metodo - Url de Emitir nomina Alegra
  # Fecha Creacion: 13-Junio-2022
  # Autor: AFP
  def select_url_alegra_emitir_nomina
    [
      ['PRUEBA', 'https://sandbox-api.alegra.com/e-provider/col/v1/payrolls'],
      ['PRODUCCION', 'https://api.alegra.com/e-provider/col/v1/payrolls']
    ]
  end

  # Descripcion: Metodo - Url para crear empresa en Alegra
  # Fecha Creacion: 13-Junio-2022
  # Autor: AFP
  def select_url_alegra_crear_empresa
    [
      ['PRUEBA', 'https://sandbox-api.alegra.com/e-provider/col/v1/companies'],
      ['PRODUCCION', 'https://api.alegra.com/e-provider/col/v1/companies']
    ]
  end

  # Descripcion: Metodo - Url para habilitar empresa en Alegra
  # Fecha Creacion: 13-Junio-2022
  # Autor: AFP
  def select_url_alegra_crear_empresa
    [
      ['PRUEBA', 'https://sandbox-api.alegra.com/e-provider/col/v1/test-sets'],
      ['PRODUCCION', 'https://api.alegra.com/e-provider/col/v1/test-sets']
    ]
  end

  def select_sinopayu
    [
      ['SI', 1],
      ['NO', 0]
    ]
  end

  def paginate(collection, params = {})
    will_paginate collection, params.merge(:renderer => RemoteLinkPaginationHelper::LinkRenderer)
  end

  def select_tipo_sangre
    [["O-", "O-"], ["O+", "O+"], ["A-", "A-"], ["A+", "A+"], ["B-", "B-"], ["B+", "B+"], ["AB-", "AB-"], ["AB+", "AB+"]]
  end

  def select_talla_conjunto
    [
      ["S(8)", "S"],
      ["M(10)", "M"],
      ["L(12)", "L"],
      ["XL(14)", "XL"],
      ["XXL(16)", "XXL"],
      ["XXXL(18)", "XXXL"],
      ["XXXXL(20)", "XXXXL"],
      ["XXXXXL(22)", "XXXXXL"]
    ]
  end

  def select_talla_pantalon
    [
      ["28", "28"],
      ["30", "30"],
      ["32", "32"],
      ["34", "34"],
      ["36", "36"],
      ["38", "38"],
      ["40", "40"]
    ]
  end

  def select_talla_camiseta
    [
      ["S(36)", "S"],
      ["M(38)", "M"],
      ["L(40)", "L"],
      ["XL(42)", "XL"],
      ["XXL(44)", "XXL"],
      ["XXXL(46)", "XXXL"],
      ["XXXXL(48)", "XXXXL"]
    ]
  end

  def select_tipo_cargue_examen
    [
      ["CARGAR", "CARGAR"],
      ["ACTUALIZAR", "ACTUALIZAR"]
    ]
  end

  def select_opcion(encuestapregunta_id)
    dato = []
    Encuestapreopcion.where("encuestapregunta_id = #{encuestapregunta_id}").each do |encuestapreopcion|
      dato << ["#{encuestapreopcion.respuesta}", "#{encuestapreopcion.id}"]
    end
    return dato
  end

  def select_encuesta_clase
    [
      ["CORRECTO", "CORRECTO"],
      ["INCORRECTO", "INCORRECTO"]
    ]
  end

  def select_clasificacion_respuesta
    [
      ["CORRECTO", 1],
      ["INCORRECTO", 0]
    ]
  end

  def select_tipo_bachiller
    [
      ["CLASICO", "CLASICO"],
      ["TECNICO", "TECNICO"],
      ["COMERCIAL", "COMERCIAL"],
      ["OTRO", "OTRO"]
    ]
  end

  def select_tipo_educacion
    [
      ["TECNICO", "TECNICO"],
      ["TECNOLOGICO", "TECNOLOGICO"],
      ["PROFESIONAL", "PROFESIONAL"]

    ]
  end

  def select_horario_educacion
    [
      ["DIURNO", "DIURNO"],
      ["NOCTURNO", "NOCTURNO"],
      ["FIN DE SEMANA", "FIN DE SEMANA"],
      ["A DISTANCIA", "A DISTANCIA"]

    ]
  end

  def select_tipo_contrato_form
    [
      ["INDEFINIDO", "INDEFINIDO"],
      ["FIJO", "FIJO"]
    ]
  end

  def select_estadoCompromiso
    [
      ["PENDIENTE", "PENDIENTE"],
      ["FINALIZADO", "FINALIZADO"]
    ]
  end

  def select_contratosperiodos
    [
      ["1", 1],
      ["2", 2],
      ["3", 3],
      ["4", 4],
      ["5", 5],
      ["6", 6],
      ["7", 7],
      ["8", 8]
    ]
  end

  def select_orientacion_sexual
    [
      ['HETEROSEXUAL','HETEROSEXUAL'],
      ['HOMOSEXUAL','HOMOSEXUAL'],
      ['MUJER TRANS','MUJER TRANS'],
      ['HOMBRE TRANS','HOMBRE TRANS'],
      ['OTROS','OTROS']
    ]
  end

  def select_tipo_religion
    [
      ['CATÓLICO','CATÓLICO'],
      ['CRISTIANO','CRISTIANO'],
      ['EVANGÉLICO','EVANGÉLICO'],
      ['TESTIGO DE JEHOVÁ','TESTIGO DE JEHOVÁ'],
      ['OTRAS','OTRAS'],
      ['SIN RELIGIÓN','SIN RELIGIÓN']
    ]
  end

  def select_tipo_etnia
    [
      ['MESTIZO','MESTIZO'],
      ['GITANO (A) (ROM)','GITANO (A) (ROM)'],
      ['RAIZAL DE SAN ANDRÉS, PROVIDENCIA Y SANTA CATALINA','RAIZAL DE SAN ANDRÉS, PROVIDENCIA Y SANTA CATALINA'],
      ['PALANQUERO (A) DE SAN BASILIO','PALANQUERO (A) DE SAN BASILIO'],
      ['NEGRO (A), AFRODESCENDIENTE, AFROCOLOMBIANO (A)','NEGRO (A), AFRODESCENDIENTE, AFROCOLOMBIANO (A)'],
      ['OTRAS','OTRAS']
    ]
  end

  def select_tipo_vivienda
    [
      ['PROPIA','PROPIA'],
      ['EN ARRIENDO','EN ARRIENDO'],
      ['FAMILIAR','FAMILIAR']
    ]
  end

end
