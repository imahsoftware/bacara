class AddAccessExpirationToUsers < ActiveRecord::Migration[5.0]
  def up
    # Workaround MySQL strict mode (schema heredado con timestamps default '0000-00-00')
    execute "SET SESSION sql_mode = ''"

    # Fecha-hora hasta la cual el usuario tiene acceso. NULL = sin límite.
    # Solo se asigna a usuarios PERSONA (la lógica de negocio lo controla).
    add_column :users, :access_expires_at, :datetime

    # Marca: el usuario pidió "quiero seguir" cuando expiró su acceso.
    # Espera que un admin libere el límite (lo ponga NULL o le asigne un tiempo nuevo).
    add_column :users, :extension_requested, :boolean, default: false

    # Índices: ambos se consultan en filtros del listado de admin
    add_index :users, :access_expires_at
    add_index :users, :extension_requested
  end

  def down
    execute "SET SESSION sql_mode = ''"
    remove_index :users, :access_expires_at if index_exists?(:users, :access_expires_at)
    remove_index :users, :extension_requested if index_exists?(:users, :extension_requested)
    remove_column :users, :access_expires_at if column_exists?(:users, :access_expires_at)
    remove_column :users, :extension_requested if column_exists?(:users, :extension_requested)
  end
end
