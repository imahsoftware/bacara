class ImportFileJob < ApplicationJob

  queue_as :sidekiq

  def perform(path, is_portafolio, archivoId, *args)
    if  args[0].to_s == 'INSUMOSCCE'
      Archivo.importcce(path, is_portafolio, archivoId)
    elsif  args[0].to_s == 'INSUMOSNCCE'
      Archivo.importncce(path, is_portafolio, archivoId)
    else
      Archivo.import(path, is_portafolio, archivoId, args[0], args[1])
    end
  end
end
