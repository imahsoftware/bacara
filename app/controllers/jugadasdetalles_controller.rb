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
    slot_pendiente = Jugadasdetalle.where(jugada_id: @jugada_id).where(r_player: 0, r_banker: 0).order(orden: :desc, id: :desc).first

    if slot_pendiente
      # Actualizar el slot que dejó el PRC con la elección del usuario
      slot_pendiente.update!(r_player: tipo == "P" ? 1 : 0, r_banker: tipo == "B" ? 1 : 0)
      @detalle = slot_pendiente
    else
      # No hay slot pendiente: primeros movimientos antes de que el PRC empiece
      @detalle = Jugadasdetalle.new(jugada_id: @jugada_id, r_player:  tipo == "P" ? 1 : 0, r_banker:  tipo == "B" ? 1 : 0)
      unless @detalle.save
        respond_to do |format|
          format.js   { render js: "alert('Error al guardar el movimiento.');" }
          format.json { render json: { status: "error", errors: @detalle.errors.full_messages }, status: :unprocessable_entity }
        end
        return
      end
    end

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
    # Borrar el slot de predicción del PRC (r_player=0, r_banker=0, orden máximo)
    slot_prc = Jugadasdetalle
                 .where(jugada_id: @jugada_id)
                 .where(r_player: 0, r_banker: 0)
                 .order(orden: :desc, id: :desc)
                 .first
    slot_prc.destroy if slot_prc

    # Borrar el último registro confirmado por el usuario (r_player o r_banker = 1)
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

  # Lee el slot que el PRC dejó pre-calculado (r_player=0, r_banker=0 con orden máximo)
  # y retorna "P", "B" o "No Bet" según player1/banquer1
  def calcular_proximo_bet(jugada_id)
    slot = Jugadasdetalle
             .where(jugada_id: jugada_id)
             .where(r_player: 0, r_banker: 0)
             .order(orden: :desc, id: :desc)
             .first

    return "No Bet" unless slot

    if slot.player1.to_i > 0
      "P"
    elsif slot.banquer1.to_i > 0
      "B"
    else
      "No Bet"
    end
  end

  def set_layout
    'viewspecial'
  end
end
