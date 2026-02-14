class Ejecucion < ApplicationRecord
  belongs_to :user
  belongs_to :periodosliquidacion

  def estadocolor
    if self.estado.to_s == 'ERROR'
      "<i class='text-red'><strong>ERROR</strong></i>".html_safe
    elsif self.estado.to_s == 'PENDIENTE'
      "<i class='text-blue'><strong>PENDIENTE</strong></i>".html_safe
    elsif self.estado.to_s == 'EXITOSO'
      "EXITOSO".html_safe
    end
  end
end
