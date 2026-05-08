class CreateUsersdocs < ActiveRecord::Migration[5.0]
  def change
    create_table :usersdocs do |t|
      t.integer  :user_id, null: false
      t.string   :descripcion
      t.string   :documento_file_name
      t.string   :documento_content_type
      t.bigint   :documento_file_size
      t.datetime :documento_updated_at

      t.timestamps null: false
    end

    add_index :usersdocs, :user_id
  end
end
