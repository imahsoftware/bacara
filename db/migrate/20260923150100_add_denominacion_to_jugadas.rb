class AddDenominacionToJugadas < ActiveRecord::Migration[7.2]
  def up
    add_reference :jugadas, :denominacion, foreign_key: true, index: true

    # Backfill: las jugadas creadas antes de este cambio no tenían denominación.
    # Se les asigna Dólar (USD) por defecto.
    Jugada.reset_column_information
    usd = Denominacion.find_by(codigo: 'USD')
    Jugada.where(denominacion_id: nil).update_all(denominacion_id: usd.id) if usd
  end

  def down
    remove_reference :jugadas, :denominacion, foreign_key: true, index: true
  end
end
