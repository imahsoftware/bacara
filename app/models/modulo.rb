class Modulo < ApplicationRecord
  #audited
  
  has_many :usersmodulos
  has_many :portafolioscargosmodulos
  has_many :permisos

  enum grupo_option: {gestion: 'Gestion', parametro: 'Parametrizacion', factura: 'Facturacion', seguridad: 'Seguridad', informes: 'Informes'}

  after_save :despuesdeguardar

  def self.grupo_opciones_select
    grupo_options.map {|k, v| [v, v]}
  end

  def despuesdeguardar
    @adminusers = User.where(geintac: 'S')
    @adminusers.each do |au|
      objetouser = Usersmodulo.new(user_id: au.id, modulo_id: self.id)
      objetouser.save
    end
  end
end
