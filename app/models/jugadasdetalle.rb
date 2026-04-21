class Jugadasdetalle < ApplicationRecord
  self.table_name = "jugadasdetalles"

  belongs_to :jugada, optional: true

  validates :jugada_id, presence: true

  # Solo registros confirmados por el usuario (r_player=1 o r_banker=1)
  # El slot del PRC (r_player=0, r_banker=0) no se muestra en la tabla
  scope :jugadas, ->(jugada_id) {
    where(jugada_id: jugada_id)
      .order(:orden, :id)
  }

  # Suma SQL de acumuladof para todos los renglones de un jugada_id (PROFIT en UI)
  def self.sum_acumuladof_for_jugada(jugada_id)
    return 0 if jugada_id.blank?

    where(jugada_id: jugada_id).sum(:acumuladof)
  end

  def self.formatted_profit_for_jugada(jugada_id)
    v = sum_acumuladof_for_jugada(jugada_id).to_f
    v == v.to_i ? v.to_i.to_s : sprintf('%.1f', v)
  end

  def tipo
    return "P" if r_player == 1
    return "B" if r_banker == 1
    "?"
  end
end
