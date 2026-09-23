class FixDenominacionBackfillToUsd < ActiveRecord::Migration[7.2]
  # La migración anterior (AddDenominacionToJugadas) ya corrió y dejó todas las
  # jugadas previas a hoy con denominación Peso Colombiano (COP) por defecto.
  # Se corrige para que ese default histórico sea Dólar (USD) en su lugar,
  # tal como se pidió.
  def up
    usd = Denominacion.find_by(codigo: 'USD')
    return unless usd

    Jugada.reset_column_information
    Jugada.where('created_at < ?', Date.current.beginning_of_day)
          .update_all(denominacion_id: usd.id)
  end

  def down
    # No hay forma confiable de recuperar la denominación anterior por fila.
  end
end
