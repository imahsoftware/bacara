class Jugada < ApplicationRecord
  belongs_to :user, optional: true

  validates_presence_of :jugador

  # Jugadas no finalizadas (p. ej. otras lógicas)
  scope :sin_finalizar, -> {
    where('jugadas.estado IS NULL OR jugadas.estado <> ?', 'FINALIZADA')
  }

  # Listado: PERSONA solo sus jugadas (user_id); el resto ve todo el listado
  def self.for_user_list(user)
    return none if user.blank?

    if user.tipoconsulta.to_s == 'PERSONA'
      where(user_id: user.id)
    else
      all
    end
  end

  # PERSONA: tiene una sesión de juego activa (estado PENDIENTE) — no puede abrir otra
  def self.primera_pendiente_para(user)
    return nil if user.blank?
    return nil unless user.tipoconsulta.to_s == 'PERSONA'

    for_user_list(user)
      .where("UPPER(TRIM(IFNULL(#{table_name}.estado, ''))) = 'PENDIENTE'")
      .order(id: :desc)
      .first
  end

  def self.persona_tiene_jugada_abierta?(user)
    # “Abierta” = PENDIENTE. CERRADA o FINALIZADA no bloquean un nuevo SHOE desde baccarat.
    return false if user.blank?
    return false unless user.tipoconsulta.to_s == 'PERSONA'

    primera_pendiente_para(user).present?
  end

  # Última jugada CERRADA del usuario (para enlace "New SHOE" desde el index, mismo criterio que baccarat)
  def self.ultima_cerrada_para_nueva_shoe(user)
    return nil if user.blank?
    return nil unless user.tipoconsulta.to_s == 'PERSONA'

    for_user_list(user)
      .where("UPPER(TRIM(IFNULL(#{table_name}.estado, ''))) = 'CERRADA'")
      .order(id: :desc)
      .first
  end
end
