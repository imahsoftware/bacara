class AddGrupoOptionToModulos < ActiveRecord::Migration[7.2]
  def up
    # Corregir timestamps con defaults inválidos antes de migrar (requerido por Rails 7)
    execute "ALTER TABLE modulos MODIFY updated_at datetime NULL DEFAULT NULL"
    execute "ALTER TABLE modulos MODIFY created_at datetime NULL DEFAULT NULL"

    unless column_exists?(:modulos, :grupo_option)
      add_column :modulos, :grupo_option, :string
    end
  end

  def down
    remove_column :modulos, :grupo_option if column_exists?(:modulos, :grupo_option)
  end
end
