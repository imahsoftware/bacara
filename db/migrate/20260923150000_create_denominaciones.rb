class CreateDenominaciones < ActiveRecord::Migration[7.2]
  def up
    create_table :denominaciones do |t|
      t.string :nombre, null: false
      t.string :codigo, limit: 10
      t.string :simbolo, limit: 10
      t.string :estado, limit: 20, null: false, default: 'ACTIVO'

      t.timestamps
    end

    add_index :denominaciones, :codigo, unique: true

    # Semilla inicial: las 3 monedas mencionadas por el negocio hoy.
    # Se puede editar / agregar más desde la pantalla de administración (Denominaciones).
    now = Time.current.to_fs(:db)
    execute <<~SQL
      INSERT INTO denominaciones (nombre, codigo, simbolo, estado, created_at, updated_at) VALUES
      ('Peso Colombiano', 'COP', '$',   'ACTIVO', '#{now}', '#{now}'),
      ('Dólar',           'USD', 'US$', 'ACTIVO', '#{now}', '#{now}'),
      ('Euro',            'EUR', '€',   'ACTIVO', '#{now}', '#{now}')
    SQL
  end

  def down
    drop_table :denominaciones
  end
end
