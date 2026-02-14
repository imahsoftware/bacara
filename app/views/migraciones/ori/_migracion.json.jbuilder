json.extract! migracion, :id, :nombre, :estado, :created_at, :updated_at
json.url migracion_url(migracion, format: :json)
