class Portafolio < ApplicationRecord
	#audited

	before_update :capturar_estado_anterior
	after_update  :inactivar_usuarios_si_inactivo

	has_many :usersportafolios
	has_many :personasportafolios
	has_many :personasvehiculos
	has_many :users
	has_many :soportes
	has_many :covinocobligaciones
	has_many :portafolioscontratos
	has_many :portafoliossucursales
	has_many :personassoblgcas
	has_many :clientes
	has_many :portafoliostiposdocumentos
	has_many :portafoliostasas
	has_many :portafoliostasascambios
	has_many :portafolioscuentas
	has_many :kfgportafolios
	has_many :tiposdocumentosportafolios
	has_many :portafolioscargos
	has_many :portafoliosmetas
	has_many :portafoliosreportes
	has_many :grupos
	has_many :portafolioscomisiones
	has_many :portafoliosvehiculos
	has_many :procesosactuaciones
	has_many :portafoliospermisos
	has_many :portafoliosmodulos
	has_many :portafoliosobjetos
	has_many :portafoliosgastos
	has_many :noticias
	has_many :planesrecaudos
	has_many :procesosactportafolios
	has_many :procesosetapas
	has_many :portafoliosacciones
	has_many :portafoliostareas
	has_many :portafoliostiposprocesos
	has_many :portafoliostasasbcps
	has_many :portafoliosdemandantes
	has_many :portafoliosproveedores
	has_many :lineacreditos
	has_many :personascodeudores
	has_many :portafoliosestados
	has_many :personasoblseguros
	has_many :portafoliospersonas
	has_many :eproveedorescompras
	has_many :egresos

	has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/logo.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

	#validates :email, presence: true
	#validates :estado, presence: true
	#validates :negociacion_contado, presence: true
	#validates :nombrefile, presence: true

	def parametrizacionacuerdos
		if self.acuerdos_fechas == 'SI'
			return true
		else
			return false
		end
	end

	def logoportafolio
		return logo_empresa.to_s
=begin
		if self.id == 1
			return 'logo.png'
		elsif self.id == 2
			return 'microcinco.jpg'
		elsif self.id == 3
			return 'construmater.jpg'
		elsif self.id == 5
			return 'aseartemporal.jpg'
		elsif self.id == 4
			return 'julian.jpg'
		elsif self.id == 6
			return 'progescol.jpg'
		end
=end
	end

	private

	# Cuando el portafolio pasa a INACTIVO, inactiva automáticamente
	# a todos sus usuarios y guarda el motivo para mostrar el mensaje correcto en el login.
	def capturar_estado_anterior
		@estado_antes_del_update = estado_was
	end

	def inactivar_usuarios_si_inactivo
		# Solo proceder si el estado cambió de algo distinto a INACTIVO → INACTIVO
		return unless @estado_antes_del_update != 'INACTIVO' && estado == 'INACTIVO'

		# IDs de usuarios vinculados directamente por portafolio_id
		ids_directos = users.pluck(:id)

		# IDs de usuarios vinculados via usersportafolios (tabla many-to-many)
		ids_portafolios = Usersportafolio.where(portafolio_id: self.id).pluck(:user_id)

		# Unir ambos conjuntos y eliminar duplicados
		todos_ids = (ids_directos + ids_portafolios).uniq

		User.where(id: todos_ids, activo: 'S').update_all(
			activo:              'N',
			motivo_inactivacion: 'portafolio_inactivado'
		)
	end

end
