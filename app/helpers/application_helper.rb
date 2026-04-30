module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end

  def app_brand_name
    ENV["NOMBRE_APLICACION"].presence || "BacWins"
  end

  def app_brand_name_short
    ENV["NOMBRE_CORTO"].presence || "BacWins"
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
      [I18n.t(:helper_dia_lunes), 'LUNES'],
      [I18n.t(:helper_dia_martes), 'MARTES'],
      [I18n.t(:helper_dia_miercoles), 'MIERCOLES'],
      [I18n.t(:helper_dia_jueves), 'JUEVES'],
      [I18n.t(:helper_dia_viernes), 'VIERNES'],
      [I18n.t(:helper_dia_sabado), 'SABADO'],
      [I18n.t(:helper_dia_domingo), 'DOMINGO']
    ]
  end

  def select_act_clase
    [
      [I18n.t(:helper_aseo_normal), 'ASEO NORMAL'],
      [I18n.t(:helper_aseo_fuerte), 'ASEO FUERTE']
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
      [I18n.t(:helper_personal), 'PERSONAL']
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
      [I18n.t(:helper_tecnica_profesional), 'TECNICA PROFESIONAL'],
      [I18n.t(:helper_tecnologia), 'TECNOLOGIA'],
      [I18n.t(:helper_profesional), 'PROFESIONAL'],
      [I18n.t(:helper_cursos_especiales), 'CURSOS ESPECIALES'],
      [I18n.t(:helper_especializacion), 'ESPECIALIZACION'],
      [I18n.t(:helper_maestria), 'MAESTRIA'],
      [I18n.t(:helper_diplomados), 'DIPLOMADOS']
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
      [I18n.t(:helper_si), "SI"],
      [I18n.t(:helper_no), "NO"]
    ]
  end

  def select_tipotraslado
    [
      [I18n.t(:helper_definitivo), "DEFINITIVO"],
      [I18n.t(:helper_estabilidad_laboral), "ESTABILIDAD"],
      [I18n.t(:helper_continuidad), "CONTINUIDAD"],
      [I18n.t(:helper_centro_trabajo_cargo), "CENTROCARGO"]
    ]
  end

  def select_clase_visita
    datos = []
    datos << [I18n.t(:helper_seguimiento), "SEGUIMIENTO"]
    datos << [I18n.t(:helper_reunion), "REUNION"]
    datos << [I18n.t(:helper_servicio_especial), "SERVICIO ESPECIAL"]
    Userspermiso.where("user_id = #{is_admin} and objeto_id = 150").each do |a|
      datos << [I18n.t(:helper_teletrabajo), "TELETRABAJO"]
    end
    Userspermiso.where("user_id = #{is_admin} and objeto_id = 151").each do |a|
      datos << [I18n.t(:helper_brigada_aseo), "BRIGADA DE ASEO"]
    end
    return datos
  end

  def select_zapatos
    [
      [I18n.t(:helper_punteras), "PUNTERAS"],
      [I18n.t(:helper_dialectrica), "DIALECTRICA"],
      [I18n.t(:helper_sin_puntera), "SIN PUNTERA"],
      [I18n.t(:helper_plastica), "PLASTICA"],
      [I18n.t(:helper_no_aplica), "NO APLICA"]
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
      [I18n.t(:helper_no), "NO"]
    ]
  end

  def select_no
    [
      [I18n.t(:helper_no), "NO"]
    ]
  end

  def select_genero
    [
      [I18n.t(:helper_masculino), "MASCULINO"],
      [I18n.t(:helper_femenino), "FEMENINO"]
    ]
  end

  def select_situacion_econo
    [
      [I18n.t(:helper_empleado), "EMPLEADO"],
      [I18n.t(:helper_independiente), "INDEPENDIENTE"],
      [I18n.t(:helper_desempleado), "DESEMPLEADO"],
      [I18n.t(:helper_pensionado), "PENSIONADO"],
      [I18n.t(:helper_sin_dato), "SIN DATO"]
    ]
  end

  def select_tiposatencion
    [
      [I18n.t(:helper_personalizada), "PERSONALIZADA"],
      [I18n.t(:helper_telefonica), "TELEFONICA"],
      [I18n.t(:helper_domiciliaria), "DOMICILIARIA"],
      [I18n.t(:helper_correo_fisico), "CORREO FISICO"],
      [I18n.t(:helper_correo_electronico), "CORREO ELECTRONICO"],
      [I18n.t(:helper_otra), "OTRA"]
    ]
  end

  def select_tipogecasr
    [
      [I18n.t(:helper_personalizada), "PERSONALIZADA"],
      [I18n.t(:helper_telefonica), "TELEFONICA"],
      [I18n.t(:helper_domiciliaria), "DOMICILIARIA"],
      [I18n.t(:helper_correo_fisico), "CORREO FISICO"],
      [I18n.t(:helper_correo_electronico), "CORREO ELECTRONICO"],
      [I18n.t(:helper_promesa_pago), "PROMESA PAGO"],
      [I18n.t(:helper_otra), "OTRA"]
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
      [I18n.t(:helper_persona_natural), "PERSONA NATURAL"],
      [I18n.t(:helper_persona_juridica), "PERSONA JURIDICA"]
    ]
  end

  def select_estadocivil
    [
      [I18n.t(:helper_casado), "CASADO"],
      [I18n.t(:helper_divorciado), "DIVORCIADO"],
      ["ND", "ND"],
      ["Q.E.P.D.", "Q.E.P.D."],
      [I18n.t(:helper_separado), "SEPARADO"],
      [I18n.t(:helper_estadocivil_soltero), "SOLTERO"],
      [I18n.t(:helper_union_libre), "UNION LIBRE"],
      [I18n.t(:helper_viudo), "VIUDO"]
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
      [I18n.t(:helper_si), "S"],
      [I18n.t(:helper_no), "N"]
    ]
  end

  def select_sn_users
    [
      [I18n.t(:helper_si), "S"],
      [I18n.t(:helper_no), "N"]
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
      [I18n.t(:helper_persona), "PERSONA"],
      [I18n.t(:helper_todo), "TODO"]
    ]
  end

  def select_estado
    [
      [I18n.t(:helper_activo), "ACTIVO"],
      [I18n.t(:helper_inactivo), "INACTIVO"]
    ]
  end

  def select_tipo_soporte
    [
      [I18n.t(:helper_desarrollo_nuevo), "DESARROLLO NUEVO"],
      [I18n.t(:helper_solicitud_soporte), "SOLICITUD SOPORTE"]
    ]
  end

  def select_tipo_capacitaciondocs
    [
      [I18n.t(:helper_documento), "DOCUMENTO"],
      ["VIDEO", "VIDEO"],
      ["LINK", "LINK"]
    ]
  end

  def select_estado_tarea
    [
      [I18n.t(:helper_pendiente), "0"],
      [I18n.t(:helper_completo), "1"]
    ]
  end

  def select_debcre
    [
      [I18n.t(:helper_debito), "DEBITO"],
      [I18n.t(:helper_credito), "CREDITO"]
    ]
  end

  def select_estadoperiodos
    [
      [I18n.t(:helper_pendiente), "P"],
      [I18n.t(:helper_consolidado), "C"]
    ]
  end

  def select_estadoinsumo
    [
      [I18n.t(:helper_activo), "ACTIVO"],
      [I18n.t(:helper_inactivo), "INACTIVO"],
      [I18n.t(:helper_pendiente), "PENDIENTE"]
    ]
  end

  def select_estado_ac
    [
      [I18n.t(:helper_activo), "ACTIVO"],
      [I18n.t(:helper_inactivo), "INACTIVO"]
    ]
  end

  def select_categoria_documentos
    [
      [I18n.t(:helper_socioeconomicos), "SOCIOECONÓMICOS"],
      [I18n.t(:helper_academicos), "ACADÉMICOS"],
      [I18n.t(:helper_financieros), "FINANCIEROS"]
    ]
  end

  def select_estado_portafolios
    [
      [I18n.t(:helper_activo), "ACTIVO"],
      [I18n.t(:helper_inactivo), "INACTIVO"]
    ]
  end

  def select_estadoestudiante2
    [
      [I18n.t(:helper_activo), "ACTIVO"],
      [I18n.t(:helper_inactivo), "INACTIVO"]
    ]
  end

  def select_mes
    [
      [I18n.t(:helper_mes_enero), '01'],
      [I18n.t(:helper_mes_febrero), '02'],
      [I18n.t(:helper_mes_marzo), '03'],
      [I18n.t(:helper_mes_abril), '04'],
      [I18n.t(:helper_mes_mayo), '05'],
      [I18n.t(:helper_mes_junio), '06'],
      [I18n.t(:helper_mes_julio), '07'],
      [I18n.t(:helper_mes_agosto), '08'],
      [I18n.t(:helper_mes_septiembre), '09'],
      [I18n.t(:helper_mes_octubre), '10'],
      [I18n.t(:helper_mes_noviembre), '11'],
      [I18n.t(:helper_mes_diciembre), '12']
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
      [I18n.t(:helper_mes_diciembre), '12']
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
      [I18n.t(:helper_pendiente), "PENDIENTE"],
      [I18n.t(:helper_en_proceso), "EN PROCESO"],
      [I18n.t(:helper_finalizado), "FINALIZADO"]
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
      [I18n.t(:helper_nivel_gestion), 1],
      [I18n.t(:helper_nivel_cargues), 6],
      [I18n.t(:helper_nivel_procesos), 2],
      [I18n.t(:helper_nivel_parametrizacion), 3],
      [I18n.t(:helper_nivel_seguridad), 4],
      [I18n.t(:helper_nivel_parametrizacion_educacion), 5]
    ]
  end

  def select_prioridad
    [
      [I18n.t(:helper_extremo), "EXTREMO"],
      [I18n.t(:helper_alta), "ALTA"],
      [I18n.t(:helper_media), "MEDIA"],
      [I18n.t(:helper_baja), "BAJA"]
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
      [I18n.t(:helper_tecnico), "TECNICO"],
      [I18n.t(:helper_tecnologico), "TECNOLOGICO"],
      [I18n.t(:helper_universitario), "UNIVERSITARIO"],
      [I18n.t(:helper_posgrado), "POSGRADO"]
    ]
  end

  def select_periodicidad
    [
      [I18n.t(:helper_semestral), "SEMESTRAL"],
      [I18n.t(:helper_anual), "ANUAL"]
    ]
  end

  def select_rangocalendar
    [2017, 2018]
  end

  def select_formapagohelena
    [
      ["EFECTIVO", "EFECTIVO"],
      [I18n.t(:helper_consignacion), "CONSIGNACION"]
    ]
  end

  def select_tiposgestion
    [
      [I18n.t(:helper_cobranza), 'COBRANZA'],
      [I18n.t(:helper_virtual), 'VIRTUAL']
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
      [I18n.t(:helper_perfeccionado), "PERFECCIONADO"],
      [I18n.t(:helper_en_ejecucion), "EN EJECUCION"],
      [I18n.t(:helper_en_liquidacion), "EN LIQUIDACION"],
      [I18n.t(:helper_liquidado), "LIQUIDADO"],
      [I18n.t(:helper_anulado), "ANULADO"],
      [I18n.t(:helper_terminado), "TERMINADO"]
    ]
  end

  def select_tipovalidacion
    [
      [I18n.t(:helper_restriccion), "RESTRICCION"],
      [I18n.t(:helper_notificacion), "NOTIFICACION"]
    ]
  end

  def select_tipomodificacion
    [
      [I18n.t(:helper_plazo), "PLAZO"],
      [I18n.t(:helper_plazo_valor), "PLAZO - VALOR"],
      [I18n.t(:helper_plazo_clausulas), "PLAZO - CLAUSULAS"],
      [I18n.t(:helper_plazo_valor_clausulas), "PLAZO - VALOR - CLAUSULAS"],
      [I18n.t(:helper_valor), "VALOR"],
      [I18n.t(:helper_valor_clausulas), "VALOR - CLAUSULAS"],
      [I18n.t(:helper_clausulas), "CLAUSULAS"]
    ]
  end

  def select_tipoinsumo
    [
      [I18n.t(:helper_consumo), "CONSUMO"],
      [I18n.t(:helper_elementos_equipos_maquinaria), "ELEMENTOS, EQUIPOS Y MAQUINARIA"]
    ]
  end

  def select_claseinsumo
    [
      [I18n.t(:helper_colombia_compra_eficiente), "COLOMBIA COMPRA EFICIENTE"],
      [I18n.t(:helper_general), "GENERAL"]
    ]
  end

  def select_disponibilidad
    [
      [I18n.t(:helper_tiempo_completo), "TIEMPO COMPLETO"],
      [I18n.t(:helper_medio_tiempo), "MEDIO TIEMPO"]
    ]
  end

  def select_tipointerventor
    [
      [I18n.t(:helper_supervisor), "SUPERVISOR"],
      [I18n.t(:helper_coordinador), "COORDINADOR"],
      [I18n.t(:helper_interventor), "INTERVENTOR"]
    ]
  end

  def select_claseimagen
    [
      [I18n.t(:helper_contrato), "CONTRATO"],
      [I18n.t(:helper_proveedor), "PROVEEDOR"]
    ]
  end

  def select_estadoexamen
    [
      [I18n.t(:helper_aprobado), "APROBADO"],
      [I18n.t(:helper_pendiente), "PENDIENTE"],
      [I18n.t(:helper_rechazado), "RECHAZADO"],
      [I18n.t(:helper_aplazado), "APLAZADO"]
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
      [I18n.t(:helper_personal), '11020'],
      [I18n.t(:helper_insumos), '11021'],
      [I18n.t(:helper_maquinaria), '11022'],
      [I18n.t(:helper_otros), '11023'],
      [I18n.t(:helper_base_g), '11024']
    ]
  end

  def select_embargo
    [
      [I18n.t(:helper_embargo), "EMBARGO"],
      [I18n.t(:helper_libranza), "LIBRANZA"]
    ]
  end

  def select_terminodescuento
    [
      [I18n.t(:helper_quincenal), "QUINCENAL"],
      [I18n.t(:helper_mensual), "MENSUAL"]
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
      [I18n.t(:helper_devengo), "DEVENGO"],
      [I18n.t(:helper_deduccion), "DEDUCCION"],
      [I18n.t(:helper_otros_devengo), "OTROS DEVENGO"]
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
      [I18n.t(:helper_asignar), "ASIGNAR"],
      [I18n.t(:helper_quitar), "QUITAR"]
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
      [I18n.t(:helper_riesgo_1), '0.0052'], # 00522
      [I18n.t(:helper_riesgo_2), '0.0104'], # 01044
      [I18n.t(:helper_riesgo_3), '0.0243'], # 02436
      [I18n.t(:helper_riesgo_4), '0.0435'], # 04350
      [I18n.t(:helper_riesgo_5), '0.0696'] # 06960
    ]
  end

  def select_logo
    [
      ["BacWins", "logo.png"]
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
      [I18n.t(:helper_jornada_lun_sab), "LUNES-SABADO"],
      [I18n.t(:helper_jornada_lun_vie), "LUNES-VIERNES"],
      [I18n.t(:helper_jornada_lun_dom), "LUNES-DOMINGO"]
    ]
  end

  def select_proveedor
    [
      [I18n.t(:helper_regimen_comun), "RÉGIMEN COMÚN"],
      [I18n.t(:helper_regimen_simplificado), "RÉGIMEN SIMPLIFICADO"],
      [I18n.t(:helper_gran_contribuyente), "GRAN CONTRIBUYENTE"]
    ]
  end

  def select_formapago
    [
      ["EFECTIVO", "EFECTIVO"],
      [I18n.t(:helper_consignacion), "CONSIGNACION"],
      [I18n.t(:helper_transferencia), "TRANSFERENCIA"],
      [I18n.t(:helper_cheque), "CHEQUE"]
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
      [I18n.t(:helper_contrato), "CONTRATO"],
      [I18n.t(:helper_proveedor), "PROVEEDOR"]
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
      [I18n.t(:helper_peso_argentino), 'ARS'],
      [I18n.t(:helper_real_brasileno), 'BRL'],
      [I18n.t(:helper_peso_chileno), 'CLP'],
      [I18n.t(:helper_peso_colombiano), 'COP'],
      [I18n.t(:helper_peso_mexicano), 'MXN'],
      [I18n.t(:helper_nuevo_sol_peruano), 'PEN'],
      [I18n.t(:helper_dolar_americano), 'USD']
    ]
  end

  # Descripcion: Metodo - Url de token aportes en linea
  # Fecha Creacion: 20-Julio-2022
  # Autor: AFP
  def select_url_aportes
    [
      [I18n.t(:helper_prueba), 'https://marketplacepruebas.aportesenlinea.com/Transversales.Servicios.Fachada/api/ControlAcceso/Autenticar'],
      [I18n.t(:helper_produccion), 'https://marketplace.aportesenlinea.com/Transversales.Servicios.Fachada/api/ControlAcceso/Autenticar']
    ]
  end

  # Descripcion: Metodo - Url de crear cotizante
  # Fecha Creacion: 20-Julio-2022
  # Autor: AFP
  def select_url_aportes_cotizante
    [
      [I18n.t(:helper_prueba), 'https://marketplacepruebas.aportesenlinea.com/Fanaia.Servicios.Fachada/api/Cotizantes/CrearCotizante'],
      [I18n.t(:helper_produccion), 'https://marketplace.aportesenlinea.com/Fanaia.Servicios.Fachada/api/Cotizantes/ConsultarCotizantes']
    ]
  end

  # Descripcion: Metodo - Url de cetificado de aportes
  # Fecha Creacion: 20-Julio-2022
  # Autor: AFP
  def select_url_aportes_certificado
    [
      [I18n.t(:helper_prueba), 'https://aplicacionespruebas.aportesenlinea.com/Reportes.ServicioWeb/Reportes.svc/CertificadoAportes'],
      [I18n.t(:helper_produccion), 'https://aplicaciones.aportesenlinea.com/Reportes.ServicioWeb/Reportes.svc/CertificadoAportes']
    ]
  end

  # Descripcion: Metodo - Url de creacion de novedades
  # Fecha Creacion: 25-Agosto-2022
  # Autor: AFP
  def select_url_aportes_novedades
    [
      [I18n.t(:helper_prueba), 'https://marketplace.aportesenlinea.com/Fanaia.Servicios.Fachada/api/NovedadesRefactor/CrearNovedades'],
      [I18n.t(:helper_produccion), 'https://marketplace.aportesenlinea.com/Fanaia.Servicios.Fachada/api/NovedadesRefactor/CrearNovedades']
    ]
  end

  # Descripcion: Metodo - Id para aplicacion Aportes en linea
  # Fecha Creacion: 20-Julio-2022
  # Autor: AFP
  def select_aplicacion_aportes
    [
      [I18n.t(:helper_prueba), 'E2271FA7-0FCA-4293-BF6D-53414286FDB0'],
      [I18n.t(:helper_produccion), 'FBC3E3BA-C0CA-4110-9EC5-FFA0C0E629F0']
    ]
  end

  # Descripcion: Metodo - Url de Emitir nomina Alegra
  # Fecha Creacion: 13-Junio-2022
  # Autor: AFP
  def select_url_alegra_emitir_nomina
    [
      [I18n.t(:helper_prueba), 'https://sandbox-api.alegra.com/e-provider/col/v1/payrolls'],
      [I18n.t(:helper_produccion), 'https://api.alegra.com/e-provider/col/v1/payrolls']
    ]
  end

  # Descripcion: Metodo - Url para crear empresa en Alegra
  # Fecha Creacion: 13-Junio-2022
  # Autor: AFP
  def select_url_alegra_crear_empresa
    [
      [I18n.t(:helper_prueba), 'https://sandbox-api.alegra.com/e-provider/col/v1/companies'],
      [I18n.t(:helper_produccion), 'https://api.alegra.com/e-provider/col/v1/companies']
    ]
  end

  # Descripcion: Metodo - Url para habilitar empresa en Alegra
  # Fecha Creacion: 13-Junio-2022
  # Autor: AFP
  def select_url_alegra_crear_empresa
    [
      [I18n.t(:helper_prueba), 'https://sandbox-api.alegra.com/e-provider/col/v1/test-sets'],
      [I18n.t(:helper_produccion), 'https://api.alegra.com/e-provider/col/v1/test-sets']
    ]
  end

  def select_sinopayu
    [
      [I18n.t(:helper_si), 1],
      [I18n.t(:helper_no), 0]
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
      [I18n.t(:helper_cargar), "CARGAR"],
      [I18n.t(:helper_actualizar), "ACTUALIZAR"]
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
      [I18n.t(:helper_correcto), "CORRECTO"],
      [I18n.t(:helper_incorrecto), "INCORRECTO"]
    ]
  end

  def select_clasificacion_respuesta
    [
      [I18n.t(:helper_correcto), 1],
      [I18n.t(:helper_incorrecto), 0]
    ]
  end

  def select_tipo_bachiller
    [
      [I18n.t(:helper_clasico), "CLASICO"],
      [I18n.t(:helper_tecnico), "TECNICO"],
      [I18n.t(:helper_comercial), "COMERCIAL"],
      [I18n.t(:helper_otro), "OTRO"]
    ]
  end

  def select_tipo_educacion
    [
      [I18n.t(:helper_tecnico), "TECNICO"],
      [I18n.t(:helper_tecnologico), "TECNOLOGICO"],
      [I18n.t(:helper_profesional), "PROFESIONAL"]

    ]
  end

  def select_horario_educacion
    [
      [I18n.t(:helper_diurno), "DIURNO"],
      [I18n.t(:helper_nocturno), "NOCTURNO"],
      [I18n.t(:helper_fin_de_semana), "FIN DE SEMANA"],
      [I18n.t(:helper_a_distancia), "A DISTANCIA"]

    ]
  end

  def select_tipo_contrato_form
    [
      [I18n.t(:helper_indefinido), "INDEFINIDO"],
      [I18n.t(:helper_fijo), "FIJO"]
    ]
  end

  def select_estadoCompromiso
    [
      [I18n.t(:helper_pendiente), "PENDIENTE"],
      [I18n.t(:helper_finalizado), "FINALIZADO"]
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
      [I18n.t(:helper_heterosexual),'HETEROSEXUAL'],
      [I18n.t(:helper_homosexual),'HOMOSEXUAL'],
      [I18n.t(:helper_mujer_trans),'MUJER TRANS'],
      [I18n.t(:helper_hombre_trans),'HOMBRE TRANS'],
      [I18n.t(:helper_otros),'OTROS']
    ]
  end

  def select_tipo_religion
    [
      [I18n.t(:helper_catolico),'CATÓLICO'],
      [I18n.t(:helper_cristiano),'CRISTIANO'],
      [I18n.t(:helper_evangelico),'EVANGÉLICO'],
      [I18n.t(:helper_testigo_jehova),'TESTIGO DE JEHOVÁ'],
      [I18n.t(:helper_otras),'OTRAS'],
      [I18n.t(:helper_sin_religion),'SIN RELIGIÓN']
    ]
  end

  def select_tipo_etnia
    [
      [I18n.t(:helper_mestizo),'MESTIZO'],
      [I18n.t(:helper_gitano_rom),'GITANO (A) (ROM)'],
      [I18n.t(:helper_raizal),'RAIZAL DE SAN ANDRÉS, PROVIDENCIA Y SANTA CATALINA'],
      [I18n.t(:helper_palanquero),'PALANQUERO (A) DE SAN BASILIO'],
      [I18n.t(:helper_afrocolombiano),'NEGRO (A), AFRODESCENDIENTE, AFROCOLOMBIANO (A)'],
      [I18n.t(:helper_otras),'OTRAS']
    ]
  end

  def select_tipo_vivienda
    [
      [I18n.t(:helper_vivienda_propia),'PROPIA'],
      [I18n.t(:helper_vivienda_arriendo),'EN ARRIENDO'],
      [I18n.t(:helper_vivienda_familiar),'FAMILIAR']
    ]
  end

  # Módulo /jugadas en usersmodulos (sin redirect como is_permit)
  def user_can_access_jugadas_module?
    mod = Modulo.find_by(controlador: '/jugadas')
    mod.present? && Usersmodulo.where(user_id: is_admin, modulo_id: mod.id).exists?
  end

end
