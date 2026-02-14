class Iparametro < ApplicationRecord
  has_many :iparametrosformatos
  validates_presence_of :campo, :descripcion, :estado, message: "* Obligatorio"
end
