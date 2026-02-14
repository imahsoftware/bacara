module WsHelper
=begin
"TI"
"RUT"
"PAS"
"NIT"
"EX"
"CE"
"C.C."
=end
  def vlr_issocialreason(tDocumento)
    if tDocumento == 'C.C.'
      return false
    elsif tDocumento == 'NIT'
      return true
    end
  end

  def vlr_name_array(tDocumento, vlNombre)
    if tDocumento == 'C.C.'
      return ["#{vlNombre}", "#{vlNombre}"]
    elsif tDocumento == 'NIT'
      return ["#{vlNombre}"]
    end
  end

  def vlr_idtypecode(tDocumento)
    if tDocumento == 'C.C.'
      # Si es Cedula
      return 13
    elsif tDocumento == 'NIT'
      # Si es Empresa(NIT)
      return 31
    elsif tDocumento == 'PAS'
      # Si es Pasaporte
      return 41
    elsif tDocumento == 'TI'
      # Si es Tarjeta de Identidad
      return 12
    end
  end

  def vlr_fullname(tDocumento, vlNombre)
    if tDocumento == 'NIT'
      # Si es Empresa
      return vlNombre
    else
      return 'null'
    end
  end

  def vlr_person_type(tDocumento)
    if tDocumento == 'NIT'
      # Si es Empresa
      return "Company"
    else
      return "Person"
    end
  end

  def vlr_name(tDocumento, dato)
    if tDocumento == 'C.C.'
      return dato
    else
      return 'null'
    end
  end

  def vlr_firstname(tDocumento, vlPrimerNombre)
    if tDocumento == 'C.C.'
      # Si es Persona Nombre
      return vlPrimerNombre
    else
      return 'null'
    end
  end

  def vlr_lastname(tDocumento, vlPrimerApellido)
    if tDocumento == 'C.C.'
      # Si es Persona Apellido
      return vlPrimerApellido
    else
      return 'null'
    end
  end
end
