class MenusController < ApplicationController
  layout :set_layout
  # before_action :verificardatos, if: :user_signed_in?
  before_action :validatesession
  before_action :redirigir_a_jugadas_index, only: [:index], if: :user_signed_in?

  require 'rqrcode'

  def index
  end

  private

  # Inicio autenticado: ir directo al listado de jugadas.
  def redirigir_a_jugadas_index
    if current_user.tipoconsulta.to_s == 'PERSONA'
      pend = Jugada.primera_pendiente_para(current_user)
      return redirect_to(new_jugadasdetalle_path(jugada_id: pend.id)) if pend
      return redirect_to(jugadas_path)
    end

    redirect_to jugadas_path and return
  end

  def set_layout
    if ['PERSONA', 'METRO'].include?(User.find(is_admin).tipoconsulta.to_s)
      'application_admin'
    else
      'application_admin'
    end
  end
end
