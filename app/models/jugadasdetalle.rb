class Jugadasdetalle < ApplicationRecord
  self.table_name = "jugadasdetalles"

  belongs_to :jugada, optional: true

  validates :jugada_id, presence: true

  # Scope para obtener registros de una jugada ordenados
  scope :jugadas, ->(jugada_id) { where(jugada_id: jugada_id).order(:id) }

  # Número de movimiento dentro de la jugada (1-based)
  def numero_movimiento
    self.class.where(jugada_id: jugada_id).where("id <= ?", id).count
  end

  # Indica si fue movimiento de Player o Banker
  def tipo
    return "P" if r_player == 1
    return "B" if r_banker == 1
    "?"
  end
end
