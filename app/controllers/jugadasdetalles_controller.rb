class JugadasdetallesController < ApplicationController
  before_action :set_jugada_id

  layout :set_layout

  # GET /jugadasdetalles/new?jugada_id=X
  # Abre la ventana modal/nueva ventana con el diseño P y B
  def new
    @jugada            = Jugada.find(@jugada_id)
    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugadasdetalles)
  end

  # POST /jugadasdetalles  (AJAX - no recarga la página)
  def create
    tipo = params[:tipo]  # "P" o "B"

    @detalle = Jugadasdetalle.new(
      jugada_id:  @jugada_id,
      r_player:  tipo == "P" ? 1 : nil,
      r_banker:  tipo == "B" ? 1 : nil
    )

    if @detalle.save
      total = Jugadasdetalle.where(jugada_id: @jugada_id).count

      if total >= 5
        ejecutar_prc_calculo_automatico(@jugada_id)
      end

      # Recargar todos los registros para actualizar la tabla
      @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
      @total_movimientos = @jugadasdetalles.count
      @proximo_bet       = calcular_proximo_bet(@jugadasdetalles)
      @nuevo_detalle     = @detalle

      respond_to do |format|
        format.js   # → app/views/jugadasdetalles/create.js.erb
        format.json { render json: { status: "ok", id: @detalle.id, total: total } }
      end
    else
      respond_to do |format|
        format.js   { render js: "alert('Error al guardar el movimiento.');" }
        format.json { render json: { status: "error", errors: @detalle.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # GET /jugadasdetalles?jugada_id=X  (AJAX - refresca tabla completa)
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

  # Ejecuta el stored procedure prc_calculo_automatico
  # Se llama a partir del 5to movimiento de cada jugada
  def ejecutar_prc_calculo_automatico(jugada_id)
    ActiveRecord::Base.connection.execute(
      "CALL prc_calculo_automatico(#{jugada_id.to_i})"
    )
  rescue => e
    Rails.logger.error "Error ejecutando prc_calculo_automatico: #{e.message}"
    # No interrumpir el flujo principal si el PRC falla
  end

  # Lógica simple para calcular el próximo bet sugerido
  # (puede ajustarse según la lógica real del procedimiento)
  def calcular_proximo_bet(registros)
    return "No Bet" if registros.empty?
    # Placeholder: la lógica real vendrá del PRC
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
