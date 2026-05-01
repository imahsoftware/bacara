class Jugada < ApplicationRecord
  belongs_to :user, optional: true
  has_many :jugadasdetalles

  validates_presence_of :monto_apostar

  # ── UUID público para URLs ─────────────────────────────────────
  # Se genera automáticamente al crear; el integer id sigue siendo PK
  # y FK interna (jugadasdetalles.jugada_id, etc.).
  before_create :generate_uuid

  def to_param
    uuid.presence || id.to_s
  end

  # Resuelve un valor que viene de URL (puede ser UUID o id integer
  # durante el periodo de transición) y devuelve la Jugada.
  def self.find_by_param!(value)
    raise ActiveRecord::RecordNotFound, "Jugada param blank" if value.blank?
    if value.to_s =~ /\A\d+\z/
      find(value)
    else
      find_by!(uuid: value)
    end
  end

  def self.find_by_param(value)
    return nil if value.blank?
    if value.to_s =~ /\A\d+\z/
      find_by(id: value)
    else
      find_by(uuid: value)
    end
  end

  private

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end

  public

  # Jugadas no finalizadas (p. ej. otras lógicas)
  scope :sin_finalizar, -> {
    where('jugadas.estado IS NULL OR jugadas.estado <> ?', 'FINALIZADA')
  }

  # Listado: PERSONA solo sus jugadas (user_id); el resto ve todo el listado
  # Devuelve las jugadas que el usuario actual puede listar:
  # - PERSONA: solo las suyas propias (filtra por user_id)
  # - sygma/geintac (geintac == 'S'): TODAS las jugadas
  # - Admin no-sygma: solo jugadas de usuarios cuyo portafolio_id esté asignado al admin
  #   (vía usersportafolios + el propio portafolio_id del admin como fallback)
  def self.for_user_list(user)
    return none if user.blank?

    return where(user_id: user.id) if user.tipoconsulta.to_s == 'PERSONA'

    return all if user.geintac.to_s.upcase == 'S'

    # Admin no-sygma: portafolios asignados vía usersportafolios + su propio portafolio_id
    portafolio_ids = user.usersportafolios.pluck(:portafolio_id)
    portafolio_ids << user.portafolio_id if user.portafolio_id.present?
    portafolio_ids = portafolio_ids.compact.uniq

    return none if portafolio_ids.empty?

    joins(:user).where(users: { portafolio_id: portafolio_ids })
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
