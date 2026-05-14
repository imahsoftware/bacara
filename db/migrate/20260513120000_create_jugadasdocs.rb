class CreateJugadasdocs < ActiveRecord::Migration[5.0]
  def change
    create_table :jugadasdocs do |t|
      t.integer  :jugada_id, null: false
      t.string   :descripcion
      t.string   :documento_file_name
      t.string   :documento_content_type
      t.integer  :documento_file_size
      t.datetime :documento_updated_at
      t.timestamps null: false
    end

    add_index :jugadasdocs, :jugada_id
  end
end
