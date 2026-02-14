class CreateNotificacionesplataformas < ActiveRecord::Migration[5.0]
  def change
    create_table :notificacionesplataformas do |t|
      t.integer :user_id
      t.integer :portafolio_id
      t.string :mensaje, null: false
      t.boolean :leida, default: false
      t.string :tabla
      t.integer :id_tabla
      t.string :tipo_notificacion

      t.timestamps
    end
  end
end
