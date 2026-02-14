# app/channels/application_cable/connection.rb
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.info "✅ Cable: User #{current_user.id} conectado"
    rescue => e
      # Solo loguear en caso de error real, no rechazos normales
      logger.warn "⚠️ Cable: Conexión rechazada desde #{request.ip}"
      reject_unauthorized_connection
    end

    def disconnect
      logger.info "👋 Cable: User #{current_user&.id} desconectado" if current_user
    end

    private

    def find_verified_user
      # MÉTODO 1: Intentar con Warden (sesión)
      if verified_user = env['warden']&.user
        return verified_user
      end

      # MÉTODO 2: Usar parámetro user_id de la URL
      user_id = request.params[:user_id]
      if user_id.present?
        user = User.find_by(id: user_id)
        return user if user
      end

      # Si llegamos aquí, rechazar sin tanto logging
      reject_unauthorized_connection
    end
  end
end