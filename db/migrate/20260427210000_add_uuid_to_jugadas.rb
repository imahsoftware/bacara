class AddUuidToJugadas < ActiveRecord::Migration[5.0]
  def up
    # Workaround MySQL strict mode (mismo problema que la migración de portafolios)
    execute "SET SESSION sql_mode = ''"

    add_column :jugadas, :uuid, :string, limit: 36
    add_index  :jugadas, :uuid, unique: true

    # Backfill: asignar UUIDs a jugadas existentes
    Jugada.reset_column_information
    Jugada.where(uuid: nil).find_each(batch_size: 500) do |j|
      j.update_columns(uuid: SecureRandom.uuid)
    end
  end

  def down
    execute "SET SESSION sql_mode = ''"
    remove_index  :jugadas, :uuid if index_exists?(:jugadas, :uuid)
    remove_column :jugadas, :uuid if column_exists?(:jugadas, :uuid)
  end
end
