class Userspermiso < ApplicationRecord
  #audited
  
  belongs_to :user
  belongs_to :objeto

  validates_uniqueness_of :objeto_id, scope: :user_id
  validates :objeto_id, :crea, :actualiza, :elimina, presence: true

  def buserspermiso
    "self.descripcion(#{self.mensaje})"
  end

end
