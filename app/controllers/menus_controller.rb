class MenusController < ApplicationController
  layout :set_layout
  # before_action :verificardatos, if: :user_signed_in?
  before_action :validatesession
  before_action :redirigir_persona_baccarat_o_jugadas, only: [:index], if: :user_signed_in?

  require 'rqrcode'

  def index
  end

  private

  # tipoconsulta PERSONA: al entrar al inicio, misma lógica que el login (pendiente → baccarat, si no → listado)
  def redirigir_persona_baccarat_o_jugadas
    return unless current_user.tipoconsulta.to_s == 'PERSONA'

    pend = Jugada.primera_pendiente_para(current_user)
    if pend
      redirect_to new_jugadasdetalle_path(jugada_id: pend.id) and return
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
