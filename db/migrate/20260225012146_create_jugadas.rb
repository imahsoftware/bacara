class CreateJugadas < ActiveRecord::Migration[5.0]
  def change
    create_table :jugadas do |t|
      t.string :jugador
      t.date :fecha
      t.string :estado, default: 'PENDIENTE'

      t.timestamps
    end
  end
end
