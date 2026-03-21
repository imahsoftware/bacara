class JugadasdetallesController < ApplicationController
  before_action :set_jugada_id

  layout :set_layout

  # GET /jugadasdetalles/new?jugada_id=X
  def new
    @jugada            = Jugada.find(@jugada_id)
    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugadasdetalles)
  end

  # POST /jugadasdetalles  (AJAX)
  def create
    tipo = params[:tipo]  # "P" o "B"

    total_actual = Jugadasdetalle.where(jugada_id: @jugada_id).count

    if total_actual < 4
      # ── MOVIMIENTOS 1 a 4: crear registro normalmente ──
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

      # A partir del 4to registro guardado (total pasa a ser 4),
      # ejecutar el PRC para que cree el 5to registro "pendiente" con los cálculos
      if Jugadasdetalle.where(jugada_id: @jugada_id).count >= 4
        ejecutar_prc_calculo_automatico(@detalle.id)
      end

    else
      # ── MOVIMIENTO 5 EN ADELANTE: actualizar el registro pendiente del PRC ──
      # El PRC ya creó este registro con player1, banquer1, mecanica1, etc.
      # Solo falta ponerle el resultado real (r_player / r_banker)
      registro_pendiente = Jugadasdetalle.where(jugada_id: @jugada_id)
                                         .order(id: :desc)
                                         .first

      if registro_pendiente.nil?
        respond_to do |format|
          format.js   { render js: "alert('No se encontró registro pendiente del PRC.');" }
          format.json { render json: { status: "error", errors: ["No hay registro pendiente"] }, status: :unprocessable_entity }
        end
        return
      end

      # Actualizar con el resultado real que eligió el usuario
      registro_pendiente.update!(
        r_player: tipo == "P" ? 1 : 0,
        r_banker: tipo == "B" ? 1 : 0
      )

      @detalle = registro_pendiente

      # Ejecutar el PRC para que calcule y cree el SIGUIENTE registro pendiente
      ejecutar_prc_calculo_automatico(@detalle.id)
    end

    # Recargar todos los registros para actualizar la tabla
    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugadasdetalles)
    @nuevo_detalle     = @detalle

    respond_to do |format|
      format.js   # → app/views/jugadasdetalles/create.js.erb
      format.json { render json: { status: "ok", id: @detalle.id, total: @total_movimientos } }
    end
  end

  # POST /jugadasdetalles/undo  (AJAX)
  def undo
    ultimo = Jugadasdetalle.where(jugada_id: @jugada_id).order(id: :desc).first

    if ultimo
      ultimo.destroy

      # Si quedan 5 o más, recalcular con el PRC
      total_restante = Jugadasdetalle.where(jugada_id: @jugada_id).count
      if total_restante >= 5
        ejecutar_prc_calculo_automatico(@jugada_id)
      end
    end

    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugadasdetalles)

    respond_to do |format|
      format.js   # → app/views/jugadasdetalles/undo.js.erb
      format.json { render json: { status: "ok", total: @total_movimientos } }
    end
  end

  # GET /jugadasdetalles?jugada_id=X
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
    Rails.logger.info "Ejecutando CALL prc_calculo_automatico(#{jugada_detalle_id.to_i})"
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
