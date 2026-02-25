class CreateJugadasdetalles < ActiveRecord::Migration[5.0]
  def change
    create_table :jugadasdetalles do |t|
      t.integer  :jugada_id
      t.string   :mecanica1
      t.integer  :player1
      t.integer  :banquer1
      t.integer  :resultado1
      t.integer  :r_player
      t.integer  :r_banker
      t.string   :mecanica2
      t.integer  :player2
      t.integer  :banquer2
      t.integer  :resultado2
      t.string   :mensaje
      t.integer  :final
      t.integer  :acumulado

      t.timestamps
    end

    add_index :jugadasdetalles, :jugada_id
  end
end
