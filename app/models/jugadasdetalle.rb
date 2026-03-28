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

  def tipo
    return "P" if r_player == 1
    return "B" if r_banker == 1
    "?"
  end
end
