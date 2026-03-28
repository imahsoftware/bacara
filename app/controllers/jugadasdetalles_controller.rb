class JugadasdetallesController < ApplicationController
  before_action :set_jugada_id

  layout :set_layout

  def new
    @jugada            = Jugada.find(@jugada_id)
    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugadasdetalles)
  end

  def create
    tipo = params[:tipo]  # "P" o "B"

    # Siempre insertar un nuevo registro por cada clic P/B
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

    # Ejecutar PRC cuando el total supera 5 registros (a partir del 6to movimiento)
    total_tras_insercion = Jugadasdetalle.where(jugada_id: @jugada_id).count
    if total_tras_insercion > 5
      ejecutar_prc_calculo_automatico(@detalle.id)
    end

    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugadasdetalles)
    @nuevo_detalle     = @detalle

    respond_to do |format|
      format.js
      format.json { render json: { status: "ok", id: @detalle.id, total: @total_movimientos } }
    end
  end

  def undo
    ultimo = Jugadasdetalle.where(jugada_id: @jugada_id).order(id: :desc).first

    if ultimo
      ultimo.destroy

      # Re-ejecutar PRC si aún quedan más de 5 registros
      total_restante = Jugadasdetalle.where(jugada_id: @jugada_id).count
      if total_restante > 5
        ultimo_vigente = Jugadasdetalle.where(jugada_id: @jugada_id).order(id: :desc).first
        ejecutar_prc_calculo_automatico(ultimo_vigente.id) if ultimo_vigente
      end
    end

    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugadasdetalles)

    respond_to do |format|
      format.js
      format.json { render json: { status: "ok", total: @total_movimientos } }
    end
  end

  def index
    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugadasdetalles)

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

  def calcular_proximo_bet(registros)
    return "No Bet" if registros.empty?
    "No Bet"
  end

  def set_layout
    if ['index', 'new'].include?(action_name)
      'viewspecial'
    else
      'viewspecial'
    end
  end
end
