class User < ApplicationRecord
  include InformationConcern

  devise :two_factor_authenticatable,
         :otp_secret_encryption_key => '2eb8ceeaf09042a4edda0c6dc8d8b564674f76bed3780bd220b4bd208e123823bc2b5254c40b0be9278029694b389e569ee17f1516a349a545663be7a6331e2b'

  devise :recoverable, :trackable, :validatable, :timeoutable, :lockable, :session_limitable,
         :ssl_session_verifiable

  has_many :login_activities, as: :user
  has_many :registros
  belongs_to :persona
  belongs_to :portafolio
  has_many :jugadas
  has_many :portafoliosreportes
  has_many :usersmodulos, dependent: :destroy
  has_many :userspermisos, dependent: :destroy
  has_many :usersportafolios, dependent: :destroy
  has_many :usersfechas, dependent: :destroy
  has_many :usersimagenes, dependent: :destroy
  has_many :usersvehiculos
  has_many :usersreportes
  has_many :usersvisitas
  has_many :usersparametros
  has_many :notificacionesplataformas, dependent: :destroy

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/default_user_avatar.svg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  # El email se genera automáticamente concatenando username + @bacwins.com.
  # Se actualiza siempre que el username cambie.
  before_validation :set_email_from_username

  # Tras guardar (create o update), nos aseguramos que exista una fila en
  # usersportafolios que vincule este usuario con su portafolio_id actual.
  # Esto mantiene la tabla many-to-many sincronizada para que el filtro de
  # Jugada.for_user_list funcione correctamente.
  after_save :ensure_usersportafolio_link

  validates :nombre, :username, :email, :tipoconsulta, presence: true

  validates :email, format: { with: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :multiline => true, message: "* Correo electrónico invalido" }
  validates :email, :username, uniqueness: true
  validates :identificacion, uniqueness: true

  validates :identificacion, uniqueness: { scope: :portafolio_id, message: "Ya hay un username" }, on: :create
  validates :password, presence: true, if: :valitatecountone

  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }
  before_save :antesdeguardar

  scope :name_like, -> (nombre) { where("nombre like ?", nombre)}

  def activate_otp
    self.otp_required_for_login = true
    self.otp_secret = unconfirmed_otp_secret
    self.unconfirmed_otp_secret = nil
    save!
  end

  def generate_reset_password_token
    # Genera un token único y lo asigna al atributo reset_password_token
    self.reset_password_token = SecureRandom.urlsafe_base64
    # Establece la fecha y hora de expiración del token (por ejemplo, 1 hora después del momento actual)
    self.reset_password_sent_at = Time.now.utc
  end

  def self.checkuser
    usrs = User.where(["unlock_token is not null"])
    usrs.each do |u|
      u.failed_attempts = 0
      u.unlock_token = nil
      u.locked_at = nil
      u.save(validate: false)
    end
    User.where(etapa: '-1').each do |p|
      p.password = p.identificacion
      p.etapa ='A'
      p.save(validate: false)
    end
  end

  def deactivate_otp
    self.otp_required_for_login = false
    self.otp_secret = nil
    save!
  end

  def valitatecountone
    currentuser = self.geintac rescue nil
    self.sign_in_count == 1 and currentuser == "S"
  end

  def timeout_in
    if self.geintac == "S"
      1.day
    else
      40.minutes
    end
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end

  def self.search(search, isportafolio, page)
    paginate(page: page, per_page: 15).where("portafolio_id = #{isportafolio} and (geintac = 'N' or geintac is null) and upper(nombre||username) like upper('%%#{replacespace(search.to_s)}%%')").order('nombre')
  end

  def self.searchgeintac(search, page)
    paginate(page: page, per_page: 15).where("upper(nombre||username) like upper('%%#{replacespace(search.to_s)}%%')").order('nombre')
  end

  def antesdeguardar
    self.nombre = quita_acento(self.nombre)
  end

  def quita_acento(dato)
    valor = dato.gsub('Á','A') rescue nil
    valor = valor.gsub('É','E') rescue nil
    valor = valor.gsub('Í','I') rescue nil
    valor = valor.gsub('Ó','O') rescue nil
    valor = valor.gsub('Ú','U') rescue nil
    valor = valor.gsub('Ñ','N') rescue nil
    return valor.to_s
  end

  def self.replacespace(campo)
    b = campo.sub(" ","%%")
    b = b.sub(" ","%%")
    b = b.sub(" ","%%")
    b = b.sub(" ","%%")
    return b
  end

  def nombreysucursal
    if self.portafoliossucursal_id
      return self.nombre.to_s + " (" + Portafoliossucursal.find(self.portafoliossucursal_id).descripcion.to_s + ")" rescue 0
    else
      return self.nombre.to_s
    end
  end

  def fchinforme
    return (self.fchinicio.strftime('%d-%m-%Y').to_s + ' y ' + self.fchfin.strftime('%d-%m-%Y').to_s) rescue nil
  end   

  def imagen_encabezado
    if self.usersimagenes.exists?(["clase = 'ENCABEZADO'"]) == true
       dd = Usersimagen.where("user_id = #{self.id} and clase = 'ENCABEZADO'").first
       return "#{RAILS_ROOT}/public/system/usersimagenes/#{dd.id}/original/#{dd.usersimagen_file_name.to_s}"
    else
       return "#{RAILS_ROOT}/public/images/alert1.png"
    end
  end

  def imagen_pie
    if self.usersimagenes.exists?(["clase = 'PIEDEPAGINA'"]) == true
       dd = Usersimagen.where("user_id = #{self.id} and clase = 'PIEDEPAGINA'").first
       return "#{RAILS_ROOT}/public/system/usersimagenes/#{dd.id}/original/#{dd.usersimagen_file_name.to_s}"
    else
       return "#{RAILS_ROOT}/public/images/alert1.png"
    end
  end

  def d_etapa(dato)
    if self.etapa.to_s == dato.to_s
      return 'btn btn-danger'
    else
      return 'btn btn-default'
    end
  end

  def identificacion_nombre
    user.try(:nombre)
  end

  def identificacion_nombre=(nombre)
    self.user = User.find_by(nombre: nombre) if nombre.present?
  end

  def user_nombre
    user.try(:nombre)
  end

  def user_nombre=(nombre)
    self.user = User.find_by(nombre: nombre) if nombre.present?
  end

  def cambio_user2
    user.try(:nombre)
  end

  def cambio_user2=(nombre)
    self.user = User.find_by(nombre: nombre) if nombre.present?
  end

  def self.is_auth(objeto,is_admin)
    objetoid = Objeto.find_by_descripcion(objeto.to_s).id rescue 0
    if objetoid.to_s != ""
      return Userspermiso.exists?(["user_id = ? and objeto_id = ? and crea = 'S'", is_admin, objetoid])
    else
      return false
    end
  end

  def ciudadmunicipio
    return Municipio.find(self.municipio_id).descripcion rescue nil
  end

  def nombrecompleto
    return self.nombre.to_s + ' (' + self.email.to_s + ')' # - (' + self.tipoconsulta.to_s + ')'
  end

  def nombrecompletosuper
    return self.identificacion.to_s + ' - ' + self.nombre.to_s + ' (' + self.email.to_s + ')'
  end

  # ── Override de notificaciones de Devise ────────────────────────────────────
  # Bloqueamos el envío del correo de unlock_instructions porque las credenciales
  # SMTP de Gmail no están funcionando y se cae con Net::SMTPAuthenticationError,
  # mostrando la pantalla de error 500 al usuario al final de los intentos fallidos.
  # Mientras lo arreglamos, los admins pueden desbloquear manualmente desde la UI
  # (botón con candado abierto) o vía consola: User.find(id).unlock_access!
  def send_devise_notification(notification, *args)
    return if notification == :unlock_instructions
    super
  end

  # ── Inmunidad al bloqueo para usuarios geintac (Imah/admins internos) ───────
  # Los usuarios con geintac == 'S' nunca se bloquean por failed_attempts.
  # 1) lock_access! es no-op → Devise no marca el lock en BD
  # 2) access_locked? siempre false → aunque tengan un locked_at viejo, pueden entrar
  def geintac?
    geintac.to_s.upcase == 'S'
  end

  def lock_access!(opts = {})
    return if geintac?
    super
  end

  def access_locked?
    return false if geintac?
    super
  end

  private

  # Genera el email automáticamente como "<username>@bacwins.com".
  # Solo se ejecuta cuando:
  #   - es un usuario nuevo (new_record?), o
  #   - el usuario existente no tiene email (en blanco)
  # Esto preserva los correos reales de usuarios ya existentes.
  def set_email_from_username
    return if username.blank?
    return unless new_record? || email.blank?
    self.email = "#{username.to_s.strip.downcase}@bacwins.com"
  end

  # Crea la fila en usersportafolios si no existe ya.
  # Mantiene sincronizada la tabla usersportafolios con el portafolio_id actual del usuario.
  # Como un usuario solo puede pertenecer a UN portafolio:
  # 1. Elimina cualquier asociación anterior
  # 2. Crea/actualiza la asociación con el portafolio actual
  def ensure_usersportafolio_link
    return if portafolio_id.blank?
    
    # Eliminar todas las asociaciones anteriores (excepto la actual)
    usersportafolios.where.not(portafolio_id: portafolio_id).delete_all
    
    # Crear o mantener la asociación con el portafolio actual
    usersportafolios.find_or_create_by(portafolio_id: portafolio_id)
  end
end
