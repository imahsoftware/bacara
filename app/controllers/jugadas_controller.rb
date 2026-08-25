class JugadasController < ApplicationController
  before_action :set_jugada, only: [:show, :edit, :update, :destroy]
  before_action :reject_if_cerrada, only: [:edit, :update, :destroy]

  layout :set_layout
  before_action :checkaccess
  before_action :persona_redirige_pendiente_a_baccarat, only: [:index]

  def checkaccess
    return true if current_user.tipoconsulta.to_s == 'PERSONA'
    return is_permit('jugadas')
  end

  # tipoconsulta PERSONA: con jugada PENDIENTE, baccarat tiene prioridad sobre el listado
  def persona_redirige_pendiente_a_baccarat
    return unless current_user.tipoconsulta.to_s == 'PERSONA'
    return unless request.format.html?

    pend = Jugada.primera_pendiente_para(current_user)
    redirect_to new_jugadasdetalle_path(jugada_id: pend.to_param) and return if pend
  end

  def index
    @jugadas_base = jugadas_scope_base
    @portafolio_tabs = build_portafolio_tabs(@jugadas_base)
    @persona_bloquea_nueva_jugada = Jugada.persona_tiene_jugada_abierta?(current_user)
    @persona_ultima_cerrada = Jugada.ultima_cerrada_para_nueva_shoe(current_user)

    # Pre-cargar el primer tab para que no necesite AJAX al cargar la página
    if @portafolio_tabs.present?
      @first_portafolio_id = @portafolio_tabs.first[:id]
      @jugadas = @jugadas_base
                 .joins(:user)
                 .where(users: { portafolio_id: @first_portafolio_id })
                 .order(id: :desc)
      @daily_totals = compute_daily_totals(@jugadas)
    end

    respond_to do |format|
      format.html
    end
  end

  # Carga diferida por tab (portafolio) para index.
  def tabla_portafolio
    @jugadas_base = jugadas_scope_base
    portafolio_id = params[:portafolio_id].to_i

    unless allowed_portafolio_ids(@jugadas_base).include?(portafolio_id)
      head :forbidden and return
    end

    @jugadas = @jugadas_base
               .joins(:user)
               .where(users: { portafolio_id: portafolio_id })
               .order(id: :desc)
    @daily_totals = compute_daily_totals(@jugadas)

    render partial: 'jugadas/tabla_portafolio'
  end

  # Búsqueda de usuario para ver historial completo de jugadas (sin límite de fecha).
  def tabla_usuario
    @consulta = params[:q].to_s.strip
    users_scope = users_with_jugadas_scope
    @selected_user = nil
    @matched_users = []

    if params[:user_id].present?
      @selected_user = users_scope.find_by(id: params[:user_id].to_i)
    elsif @consulta.present?
      @selected_user = find_user_for_query(users_scope, @consulta)
      @matched_users = search_users_for_query(users_scope, @consulta) if @selected_user.blank?
    end

    if @selected_user.present?
      @jugadas = Jugada.for_user_list(current_user)
                       .includes(:user)
                       .where(user_id: @selected_user.id)
                       .order(id: :desc)
      @daily_totals = compute_daily_totals(@jugadas)
    end

    render partial: 'jugadas/tabla_usuario_resultados'
  end

  # Búsqueda combinada: por jugada (ID) o por usuario
  def tabla_buscar
    @consulta = params[:q].to_s.strip
    @jugada = nil
    @selected_user = nil
    @matched_users = []
    @error = nil
    @search_type = nil

    if params[:user_id].present?
      users_scope = users_with_jugadas_scope
      @selected_user = users_scope.find_by(id: params[:user_id].to_i)
      if @selected_user.present?
        @search_type = 'usuario'
      else
        @error = 'Usuario no encontrado o sin acceso.'
      end
    elsif @consulta.present?
      # Primero intentar buscar por ID de jugada (si es un número)
      if @consulta.to_i.to_s == @consulta || @consulta =~ /^\d+$/
        jugada_id = @consulta.to_i
        if jugada_id > 0
          @jugada = Jugada.for_user_list(current_user).find_by(id: jugada_id)
          @search_type = 'jugada' if @jugada.present?
          @error = "No tienes permiso para ver esta jugada" if @jugada.blank? && Jugada.exists?(jugada_id)
        end
      end

      # Si no encontró jugada, buscar por usuario
      if @jugada.blank? && @search_type.blank?
        users_scope = users_with_jugadas_scope
        @selected_user = find_user_for_query(users_scope, @consulta)
        @matched_users = search_users_for_query(users_scope, @consulta) if @selected_user.blank?
        @search_type = 'usuario' if @selected_user.present? || @matched_users.present?
      end
    end

    if @jugada.present?
      # Relation (no Array): _tabla usa .order sobre @jugadas
      @jugadas = Jugada.where(id: @jugada.id).includes(:user).order(id: :desc)
      @daily_totals = compute_daily_totals(@jugadas)
    elsif @selected_user.present?
      @jugadas = Jugada.for_user_list(current_user)
                       .includes(:user)
                       .where(user_id: @selected_user.id)
                       .order(id: :desc)
      @daily_totals = compute_daily_totals(@jugadas)
    else
      @jugadas = Jugada.none
      @daily_totals = {}
    end

    render partial: 'jugadas/tabla_buscar_resultados'
  rescue => e
    @error = "Error al buscar: #{e.message}"
    @jugadas = Jugada.none
    @daily_totals = {}
    render partial: 'jugadas/tabla_buscar_resultados'
  end

  # Devuelve hash { Date => Float } con profit total por día para un scope dado.
  def compute_daily_totals(jugadas_scope)
    return {} if jugadas_scope.blank?

    # Si es un Array, convertir a scope
    if jugadas_scope.is_a?(Array)
      jugada_ids = jugadas_scope.map(&:id)
      jugadas_scope = Jugada.where(id: jugada_ids)
    end

    # :final, no :acumuladof — mismo campo que usa el PROFIT en la pantalla de juego
    # (Jugadasdetalle.sum_acumuladof_for_jugada), para que los totales coincidan.
    rows = Jugadasdetalle
           .joins(:jugada)
           .merge(jugadas_scope.except(:order))
           .group('DATE(jugadas.created_at)')
           .sum(:final)

    rows.each_with_object({}) do |(day, amount), out|
      out[day.to_date] = amount.to_f
    end
  end
  helper_method :compute_daily_totals

  def show
    respond_to do |format|
      format.js
      format.html { redirect_to jugadas_path }
    end
  end

  def new
    @valor_apuesta = Iparametro.find_by(campo: 'VALOR_APUESTA')&.valor
    if current_user.tipoconsulta.to_s == 'PERSONA' && Jugada.persona_tiene_jugada_abierta?(current_user)
      respond_to do |format|
        format.js { render js: "alert(#{I18n.t(:jugada_en_curso_pendiente).to_json});" }
      end
      return
    end

    @active_record = Jugada.find(params[:active_id]) if params[:active_id].present?
    @jugada = Jugada.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Jugada.for_user_list(current_user).find(params[:active_id]) if params[:active_id].present?
    @jugada = Jugada.for_user_list(current_user).find(params[:id])
    respond_to { |format| format.js }
  end

  def create
    if current_user.tipoconsulta.to_s == 'PERSONA' && Jugada.persona_tiene_jugada_abierta?(current_user)
      respond_to do |format|
        format.js { render js: "alert(#{I18n.t(:jugada_en_curso_pendiente).to_json});" }
      end
      return
    end

    @jugada = Jugada.new(jugada_params)
    @jugada.user_id = current_user.id
    @jugada.fecha = Time.current
    @jugada.estado = 'PENDIENTE' if @jugada.estado.blank?
    respond_to do |format|
      if @jugada.save
        @jugada.update(jugador: "SHOE#{@jugada.id}") if @jugada.jugador.blank?
        #flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "window.location = #{new_jugadasdetalle_path(jugada_id: @jugada.to_param).to_json};" }
      else
        format.js { render 'layouts/errors', locals: { object: @jugada } }
      end
    end
  end

  def detalle_jugadas
    # Solo admins (no-PERSONA) pueden generar el PDF
    if current_user.tipoconsulta.to_s == 'PERSONA'
      redirect_to jugadas_path, alert: I18n.t(:accion_no_permitida) and return
    end

    # Blindado contra IDOR: solo jugadas que el usuario tiene permitidas ver.
    raw = params[:id].to_s
    scope = Jugada.for_user_list(current_user)
    @jugada = if raw =~ /\A\d+\z/
                scope.find_by(id: raw)
              else
                scope.find_by(uuid: raw)
              end

    if @jugada.blank?
      redirect_to jugadas_path, alert: I18n.t(:no_tiene_acceso_jugada) and return
    end

    # Orden estable para que el PDF salga consistente
    @jugadasdetalles = @jugada.jugadasdetalles.order(:orden, :id)

    # Mostrar mecánicas en el PDF cuando el usuario actual NO es PERSONA (mismo criterio que la UI live)
    @pdf_show_mecanicas = current_user.tipoconsulta.to_s != 'PERSONA'

    pdf_filename = "Jugada-#{@jugada.jugador.to_s.downcase.presence || @jugada.id}"

    respond_to do |format|
      format.pdf { render pdf: pdf_filename,
                          template: "jugadas/detalle_jugadas",
                          formats: [:html],
                          encoding: "UTF-8",
                          page_size: 'Letter',
                          orientation: 'Portrait',
                          margin: { top: 12, bottom: 12, left: 10, right: 10 } }
    end
  end

  # Solo PERSONA, desde baccarat (viewspecial): crea jugada y abre su detalle.
  def nueva_shoe
    unless ['PERSONA', 'TODO'].include?(current_user.tipoconsulta.to_s)
      redirect_to root_path, alert: I18n.t(:accion_no_permitida)
      return
    end

    from = Jugada.for_user_list(current_user).find_by_param(params[:from_jugada_id])
    if from.blank? || from.estado.to_s.upcase != 'CERRADA'
      redirect_back fallback_location: jugadas_path, alert: I18n.t(:solo_crear_jugada_cuando_cerrada)
      return
    end

    if current_user.tipoconsulta.to_s == 'PERSONA' && Jugada.persona_tiene_jugada_abierta?(current_user)
      redirect_back fallback_location: new_jugadasdetalle_path(jugada_id: from.to_param), alert: I18n.t(:otra_jugada_pendiente)
      return
    end

    @jugada = Jugada.new(
      user_id:  current_user.id,
      fecha:    Date.current,
      estado:   'PENDIENTE',
      jugador:  'SHOE' # luego: SHOE + id
    )
    if @jugada.save
      @jugada.update!(jugador: "SHOE#{@jugada.id}")
      redirect_to new_jugadasdetalle_path(jugada_id: @jugada.to_param)
    else
      msg = @jugada.errors.full_messages.to_sentence
      redirect_back fallback_location: jugadas_path, alert: msg
    end
  end

  def update
    respond_to do |format|
      if @jugada.update(jugada_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @jugada } }
      end
    end
  end

  def destroy
    @jugada.destroy
    respond_to do |format|
      flash['success'] = I18n.t(:notice_elimina_msj)
      format.js { render inline: "location.reload();" }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_jugada
    # Soporta tanto UUID (URLs nuevas) como id integer (URLs viejas en transición)
    scope = Jugada.for_user_list(current_user)
    @jugada = if params[:id].to_s =~ /\A\d+\z/
                scope.find(params[:id])
              else
                scope.find_by!(uuid: params[:id])
              end
  end

  def reject_if_cerrada
    return unless @jugada&.estado.to_s.strip.upcase == "CERRADA"

    msg = I18n.t(:jugada_cerrada_no_editar)
    respond_to do |format|
      format.html { redirect_to jugadas_path, alert: msg }
      format.js   { render js: "alert(#{msg.to_json});" }
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def jugada_params
    params.require(:jugada).permit!
  end

  def jugadas_scope_base
    Jugada.for_user_list(current_user)
          .includes(:user)
          .where('jugadas.created_at >= ?', 10.days.ago.beginning_of_day)
  end

  def allowed_portafolio_ids(scope)
    scope.joins(:user).distinct.pluck('users.portafolio_id').compact
  end

  def build_portafolio_tabs(scope)
    portafolio_ids = allowed_portafolio_ids(scope)
    return [] if portafolio_ids.empty?

    counts = scope.joins(:user).group('users.portafolio_id').count
    names_by_id = Portafolio.where(id: portafolio_ids).pluck(:id, :nombre).to_h

    portafolio_ids.sort.map do |id|
      raw_name = names_by_id[id].presence || "Portafolio #{id}"
      {
        id: id,
        name: format_portfolio_tab_name(raw_name),
        count: counts[id].to_i
      }
    end
  end

  # Primera letra mayúscula, resto minúsculas (respeta UTF-8 / acentos).
  def format_portfolio_tab_name(label)
    s = label.to_s.strip
    return s if s.blank?

    s.mb_chars.capitalize.to_s
  end

  def users_with_jugadas_scope
    user_ids_scope = Jugada.for_user_list(current_user).where.not(user_id: nil).select(:user_id)
    User.where(id: user_ids_scope).distinct
  end

  def find_user_for_query(scope, query)
    q = query.to_s.strip
    return nil if q.blank?

    if q.match?(/\A\d+\z/)
      by_id = scope.find_by(id: q.to_i)
      return by_id if by_id.present?

      by_ident = scope.find_by(identificacion: q)
      return by_ident if by_ident.present?
    end

    scope.where('LOWER(users.username) = ?', q.downcase).first ||
      scope.where('LOWER(users.nombre) = ?', q.downcase).first
  end

  def search_users_for_query(scope, query)
    q = query.to_s.strip
    return [] if q.blank?

    normalized = "%#{q.upcase}%"
    scope.where('UPPER(users.nombre) LIKE :q OR UPPER(users.username) LIKE :q OR users.identificacion LIKE :q2',
                q: normalized,
                q2: "%#{q}%")
         .order(:nombre)
         .limit(25)
  end

  def set_layout
    if ['index', 'new'].include?(action_name)
      'application_admin'
    elsif ['edit'].include?(action_name)
      'application_users'
    else
      'application'
    end
  end
end
