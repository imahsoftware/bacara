class Usersmodulo < ApplicationRecord
  #audited
  
  belongs_to :user
  belongs_to :modulo

  validates_presence_of :modulo_id
  validates_uniqueness_of :modulo_id, scope: :user_id

  def busersmodulos
    "self.descripcion(#{self.mensaje})"
  end

end
