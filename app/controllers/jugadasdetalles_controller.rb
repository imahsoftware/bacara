class JugadasdetallesController < ApplicationController
  before_action :set_jugada_id

  layout :set_layout

  def new
    @jugada            = Jugada.find(@jugada_id)
    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugada_id)
  end

  def create
    tipo = params[:tipo]  # "P" o "B"

    # Buscar el último registro de esta jugada (el que dejó el PRC con r_player=0, r_banker=0)
    ultimo = Jugadasdetalle.where(jugada_id: @jugada_id).last

    if ultimo && ultimo.r_player == 0 && ultimo.r_banker == 0

      ultimo.update!(r_player: tipo == "P" ? 1 : 0, r_banker: tipo == "B" ? 1 : 0)
      @detalle = ultimo
    else
      # No hay slot del PRC — insertar nuevo registro (primeros movimientos)
      @detalle = Jugadasdetalle.new(
        jugada_id: @jugada_id,
        r_player:  tipo == "P" ? 1 : 0,
        r_banker:  tipo == "B" ? 1 : 0
      )
      unless @detalle.save
        respond_to do |format|
          format.js   { render js: "alert('Error al guardar el movimiento.');" }
          format.json { render json: { status: "error", errors: @detalle.errors.full_messages }, status: :unprocessable_entity }
        end
        return
      end
    end

    # Correr el PRC con el id del registro actualizado/insertado
    ejecutar_prc_calculo_automatico(@detalle.id)

    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugada_id)
    @nuevo_detalle     = @detalle

    respond_to do |format|
      format.js
      format.json { render json: { status: "ok", id: @detalle.id, total: @total_movimientos } }
    end
  end

  def undo
    # Borrar el slot del PRC (último registro con r_player=0, r_banker=0)
    slot_prc = Jugadasdetalle
                 .where(jugada_id: @jugada_id)
                 .where(r_player: 0, r_banker: 0)
                 .order(id: :desc)
                 .first
    slot_prc.destroy if slot_prc

    # Borrar el último movimiento confirmado por el usuario
    ultimo = Jugadasdetalle
               .where(jugada_id: @jugada_id)
               .where("r_player = 1 OR r_banker = 1")
               .order(id: :desc)
               .first
    ultimo.destroy if ultimo

    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugada_id)

    respond_to do |format|
      format.js
      format.json { render json: { status: "ok", total: @total_movimientos } }
    end
  end

  def reset
    # Eliminar todos los registros asociados a esta jugada
    Jugadasdetalle.where(jugada_id: @jugada_id).delete_all

    @jugadasdetalles   = []
    @total_movimientos = 0
    @proximo_bet       = "No Bet"

    respond_to do |format|
      format.js { render 'undo' }
      format.json { render json: { status: "ok", total: 0 } }
    end
  end

  def index
    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugada_id)

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @jugadasdetalles }
    end
  end

  private

  def set_jugada_id
    @jugada_id = params[:jugada_id].to_i
  end

  def ejecutar_prc_calculo_automatico(jugada_detalle_id)
    ActiveRecord::Base.connection.execute("CALL prc_calculo_automatico(#{jugada_detalle_id.to_i})")
  rescue => e
    Rails.logger.error "Error ejecutando prc_calculo_automatico: #{e.message}"
  end

  # Lee el slot que el PRC dejó (r_player=0, r_banker=0, orden máximo)
  # Retorna "P", "B" o "No Bet" según player1/banquer1
  def calcular_proximo_bet(jugada_id)
    Jugada.find(jugada_id).siguiente.to_s
  end

  def set_layout
    'viewspecial'
  end
end
