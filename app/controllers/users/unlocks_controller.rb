class Users::UnlocksController < Devise::UnlocksController

  # POST /resource/unlock
  def create
    # Buscar al usuario por su dirección de correo electrónico
    user = User.find_by(email: params[:user][:email])

    # Verificar si se encontró un usuario con ese correo electrónico
    if user.present?
      # Generar un nuevo token de desbloqueo (raw para el correo, encriptado para BD)
      raw_token, enc_token = Devise.token_generator.generate(User, :unlock_token)
      user.unlock_token = enc_token
      user.locked_at  ||= Time.current
      user.save(validate: false)

      # Enviar el correo de instrucciones de desbloqueo vía SendGrid
      Bacaramail::SendmailServices.new.general(
        user.email,
        I18n.t(:users_unlock_subject),
        "devise/mailer/unlock_instructions.html.erb",
        nil,
        nil,
        raw_token,
        user.username
      )

      redirect_to root_path, notice: I18n.t(:users_unlock_email_sent)
    else
      # No se encontró usuario con ese correo
      redirect_to root_path, alert: I18n.t(:users_unlock_user_not_found)
    end
  end

  # GET /resource/unlock?unlock_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after sending unlock password instructions
  # def after_sending_unlock_instructions_path_for(resource)
  #   super(resource)
  # end

  # The path used after unlocking the resource
  # def after_unlock_path_for(resource)
  #   super(resource)
  # end
end
