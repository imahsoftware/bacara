class Periodosliquidacion < ApplicationRecord
  self.table_name = 'periodosliquidaciones'

  has_many :ejecuciones
end
