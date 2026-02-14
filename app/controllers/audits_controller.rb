class AuditsController < ApplicationController
  before_action :checkaccess
  layout :set_layout

  def checkaccess
    return is_permit('admin/audits')
  end

  def busqueda
     
  end

  def index
    proceso = params[:ubicacion][:proceso] rescue nil
    accion = params[:ubicacion][:accion] rescue nil
    fecha_inicio = params[:fecha_inicio] rescue nil
    fecha_fin = params[:fecha_fin] rescue nil
    usersearch = params[:user_id] rescue nil
    cadena = ""
    if proceso.to_s != ""
      if cadena != ""
        cadena = cadena + ' and auditable_type = ' + "'#{proceso}'"
      else
        cadena = '  auditable_type = ' + "'#{proceso}'"
      end
    end
    if accion.to_s != ""
      if cadena != ""
        cadena = cadena + ' and action = ' + "'#{accion}'"
      else
        cadena = '  action = ' + "'#{accion}'"
      end
    end
    if usersearch.to_i > 0
      if cadena != ""
        cadena = cadena + ' and user_id = ' + "'#{usersearch}'"
      else
        cadena = '  user_id = ' + "'#{usersearch}'"
      end
    end 
    if fecha_inicio.to_s != "" and fecha_fin.to_s != ""
      if cadena != ""
        cadena = cadena + " and trunc(created_at) between " + "'#{fecha_inicio.to_date}'" + ' and ' + "'#{fecha_fin.to_date}'"
      else
        cadena = " trunc(created_at) between " + "'#{fecha_inicio.to_date}'" + ' and ' + "'#{fecha_fin.to_date}'"
      end
    end      

    if cadena.to_s != ""
      @q    = Audit.where([cadena]).all
      @audits = @q.paginate(:page =>params[:page], :per_page =>15).order("id desc")
    else
      @q = Audit.ransack(params[:q])
      @audits = @q.result.paginate(page: params[:page], per_page: 150)
    end
  end

  def show
    @audit = Audit.find(params[:id])
    @hash = @audit.audited_changes
  end

  private

  def set_layout
    if ['index'].include?(action_name)
      'application_audits'
    end
  end
end
