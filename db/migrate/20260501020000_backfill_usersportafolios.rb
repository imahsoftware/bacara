class BackfillUsersportafolios < ActiveRecord::Migration[5.0]
  def up
    # Workaround MySQL strict mode (mismo patrón que las migraciones anteriores)
    execute "SET SESSION sql_mode = ''"

    # Para cada user con portafolio_id NO nulo, garantizamos una fila en
    # usersportafolios que vincule ese par (user_id, portafolio_id).
    # El NOT EXISTS evita duplicados — la migración es idempotente.
    sql = <<~SQL
      INSERT INTO usersportafolios (user_id, portafolio_id, created_at, updated_at)
      SELECT u.id, u.portafolio_id, NOW(), NOW()
      FROM users u
      WHERE u.portafolio_id IS NOT NULL
        AND NOT EXISTS (
          SELECT 1 FROM usersportafolios up
          WHERE up.user_id = u.id
            AND up.portafolio_id = u.portafolio_id
        )
    SQL

    inserted = execute(sql).affected_rows rescue nil
    say_with_time("Filas creadas en usersportafolios: #{inserted || 'N/A'}") {}
  end

  def down
    # No reversible: borraríamos asignaciones que podrían ser legítimas.
    # Si necesitas revertir, hazlo a mano por SQL.
    say "Esta migración no es reversible (no borra usersportafolios)."
  end
end
