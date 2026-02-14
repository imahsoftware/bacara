class Userstemporal < ApplicationRecord
  belongs_to :user

  validates_presence_of :identificacion, :nombre, :email, :celular, message: "* Obligatorio"
  validates :email, format: { with: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :multiline => true, message: "* Correo electrónico invalido" }
  validate :creacionusuario

  def creacionusuario
    if User.exists?(identificacion: self.identificacion.to_s.strip) == true
      errors.add :identificacion, "Esta Identificacion ya se encuentra creada."
    elsif User.exists?(["upper(username) = '#{self.email.to_s.strip}'"]) == true
      errors.add :email, "Este Email ya esta utilizado."
    else
      begin
        user = User.create(identificacion: self.identificacion.to_s.strip,
                           email:  self.email.to_s.strip,
                           password: '123456789', nombre: self.nombre.to_s,
                           tipoconsulta: 'CONTRATO', portafolio_id: 1, username: self.email.to_s.strip, activo: 'S', etapa: 'A', celular: self.celular).id
        if user
          Userspermiso.create(user_id: user, objeto_id: 13, crea:'S', actualiza:'N', elimina:'N')
        end
      end
    end
  end

end
