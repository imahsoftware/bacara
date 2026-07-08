# Modelo stub: la tabla 'personas' no existe actualmente.
# Se mantiene para compatibilidad con asociaciones legacy en User y Portafoliospersona.
# Si se necesita funcionalidad completa de Persona, crear la migración correspondiente.
class Persona < ApplicationRecord
  self.table_name = 'personas'
end
