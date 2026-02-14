json.array!(@modulos) do |modulo|
  json.extract! modulo, :id, :descripcion, :controlador, :imagen, :grupo, :color
  json.url modulo_url(modulo, format: :json)
end
