class AddMotivoInactivacionToUsers < ActiveRecord::Migration[5.0]
  def up
    execute "SET SESSION sql_mode = ''"
    # Guarda la razón por la que fue inactivado el usuario.
    # nil = inactivado manualmente por admin
    # 'portafolio_inactivado' = su portafolio fue inactivado
    add_column :users, :motivo_inactivacion, :string
  end

  def down
    execute "SET SESSION sql_mode = ''"
    remove_column :users, :motivo_inactivacion if column_exists?(:users, :motivo_inactivacion)
  end
end
