class Iparametrosformato < ApplicationRecord
  belongs_to :iparametro
  belongs_to :formato

  validates_presence_of :formato_id, :orden

end