class Users::PasswordsController < Devise::PasswordsController


  def create
    # Buscar al usuario por su dirección de correo electrónico
    user = User.find_by(username: params[:user][:username])

    # Verificar si se encontró un usuario con ese correo electrónico
    if user.present?
      # Generar y asignar un token de restablecimiento de contraseña al usuario
      user.generate_reset_password_token

      # Guardar el usuario con el nuevo token de restablecimiento de contraseña
      user.save
      # Envía el correo electrónico de notificación de restablecimiento de contraseña
      Bacaramail::SendmailServices.new.notificacionEmails(user.email, "Recuperación de Contraseña", "devise/mailer/reset_password_instructions.html.erb", nil, nil, user.reset_password_token, user.username)

      # Redirigir a donde quieras después de enviar el correo electrónico
      redirect_to root_path, notice: "Se ha enviado un correo electrónico con instrucciones para restablecer la contraseña."
    else
      # Manejar el caso en que no se encontró un usuario con esa dirección de correo electrónico
      redirect_to root_path, alert: "No se encontró un usuario con esa dirección de correo electrónico."
    end
  end

  def update
    # Obtener el usuario a través del token de restablecimiento de contraseña
    self.resource = resource_class.find_by_reset_password_token(params[:user][:reset_password_token])

    # Verificar si se encontró un usuario con el token de restablecimiento de contraseña
    if resource.present?
      # Actualizar la contraseña del usuario con los parámetros recibidos
      resource.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])

      # Verificar si la actualización de la contraseña fue exitosa
      if resource.errors.empty?
        # Redirigir a donde quieras después de actualizar la contraseña
        redirect_to root_path, notice: "La contraseña se ha actualizado correctamente."
      else
        # Mostrar errores si la actualización de la contraseña falla
        flash[:alert] = resource.errors.full_messages.join(", ")
        render :edit
      end
    else
      # Manejar el caso en que no se encontró un usuario con el token de restablecimiento de contraseña
      redirect_to root_path, alert: "El token de restablecimiento de contraseña no es válido."
    end
  end
end
