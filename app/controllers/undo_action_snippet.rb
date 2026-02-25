# Agregar acción undo al controlador
# (Añade este método dentro de JugadasdetallesController)

# POST /jugadasdetalles/undo
def undo
  ultimo = Jugadasdetalle.where(jugada_id: @jugada_id).order(:id).last
  ultimo&.destroy

  @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
  @total_movimientos = @jugadasdetalles.count
  @proximo_bet       = calcular_proximo_bet(@jugadasdetalles)

  respond_to do |format|
    format.js
    format.json { render json: { status: "ok" } }
  end
end
