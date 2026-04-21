class Jugada < ApplicationRecord
  belongs_to :user, optional: true

  validates_presence_of :jugador

  # Jugadas no cerradas (solo PERSONA usa esto para bloquear "Nueva Jugada")
  scope :sin_finalizar, -> {
    where('jugadas.estado IS NULL OR jugadas.estado <> ?', 'FINALIZADA')
  }

  # Listado: PERSONA solo propias; resto tipoconsulta (TODO, admin, etc.) ve todas
  def self.for_user_list(user)
    return none if user.blank?

    if user.tipoconsulta.to_s == 'PERSONA'
      where(user_id: user.id)
    else
      all
    end
  end

  def self.persona_tiene_jugada_abierta?(user)
    return false if user.blank?
    return false unless user.tipoconsulta.to_s == 'PERSONA'

    where(user_id: user.id).sin_finalizar.exists?
  end
end
