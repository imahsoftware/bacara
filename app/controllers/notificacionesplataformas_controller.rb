# app/controllers/notificacionesplataformas_controller.rb
class NotificacionesplataformasController < ApplicationController
  before_action :authenticate_user!

  def index
    @notificaciones = current_user.notificacionesplataformas
                                  .no_leidas
                                  .recientes
                                  .limit(5)

    render json: @notificaciones
  end

  def contador
    count = current_user.notificacionesplataformas.where(leida: false).count
    render json: { count: count }
  end

  def marcar_como_leida
    notificacion = current_user.notificacionesplataformas.find(params[:id])
    notificacion.marcar_como_leida
    head :ok
  end

  def marcar_todas_como_leidas
    current_user.notificacionesplataformas.no_leidas.update_all(leida: true)
    head :ok
  end
end