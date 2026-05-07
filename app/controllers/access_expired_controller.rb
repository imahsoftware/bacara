class AccessExpiredController < ApplicationController
  layout 'login'

  # Saltar el check de expiración para no crear un loop
  skip_before_action :check_access_expiration

  # GET /access_expired
  # Pantalla que ve el usuario PERSONA cuando su acceso ya expiró (sin opciones, solo mensaje)
  def index
    # Si llega alguien cuyo acceso aún no expiró o no es PERSONA con límite, al root
    redirect_to root_path unless current_user&.persona_con_limite?
  end

  # POST /access_expired/solicitar_extension
  # El usuario elige "Sí, quiero continuar" → marca extension_requested y sigue navegando
  def solicitar_extension
    if current_user&.persona_con_limite?
      current_user.update_columns(extension_requested: true)
    end
    redirect_back fallback_location: root_path, notice: I18n.t(:access_expired_extension_requested)
  end

  # POST /access_expired/rechazar_acceso
  # El usuario elige "No, cerrar sesión" → inactiva la cuenta y cierra sesión
  def rechazar_acceso
    if current_user
      current_user.update_columns(activo: 'N')
    end
    sign_out current_user
    redirect_to root_path, notice: I18n.t(:access_expired_session_closed)
  end
end
