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
    @jugadas_base = Jugada.for_user_list(current_user)
    # Sin paginador. Mostramos todas las jugadas de los últimos 10 días.
    # Eager loading de user para evitar N+1 cuando se muestra la columna Player.
    @jugadas = @jugadas_base
                 .includes(:user)
                 .where('jugadas.created_at >= ?', 10.days.ago.beginning_of_day)
                 .order(id: :desc)
    @persona_bloquea_nueva_jugada = Jugada.persona_tiene_jugada_abierta?(current_user)
    @persona_ultima_cerrada = Jugada.ultima_cerrada_para_nueva_shoe(current_user)

    # Totales diarios: por cada día visible, sumar el profit de TODAS las jugadas del usuario en ese día.
    @daily_totals = compute_daily_totals(@jugadas, current_user)

    respond_to do |format|
      format.html
    end
  end

  # Devuelve hash { Date => Float } con el profit total por día.
  def compute_daily_totals(jugadas, user)
    dates = jugadas.map { |j| j.created_at.to_date }.uniq
    return {} if dates.empty?

    totals = {}
    dates.each do |date|
      day_range = date.beginning_of_day..date.end_of_day
      jugada_ids = Jugada.for_user_list(user).where(created_at: day_range).pluck(:id)
      totals[date] = Jugadasdetalle.where(jugada_id: jugada_ids).sum(:acumuladof).to_f
    end
    totals
  end
  helper_method :compute_daily_totals

  def show
    respond_to { |format| format.js }
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
        flash[:notice] = "#{t :notice_crea_msj}"
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
                          template: "jugadas/detalle_jugadas.html.erb",
                          encoding: "UTF-8",
                          page_size: 'Letter',
                          orientation: 'Landscape',
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
