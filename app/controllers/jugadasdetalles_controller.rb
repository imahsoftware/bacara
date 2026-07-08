class JugadasdetallesController < ApplicationController
  before_action :set_jugada_id
  before_action :authorize_jugada_acceso
  before_action :block_unless_pendiente, only: [:create, :undo, :reset]

  layout :set_layout

  def new
    @jugada            = Jugada.for_user_list(current_user).find(@jugada_id)
    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugada_id)
    @undo_count        = undo_count_for_jugada
  end

  def create
    tipo = params[:tipo]  # "P" o "B"

    # Buscar el último registro de esta jugada (el que dejó el PRC con r_player=0, r_banker=0)
    ultimo = Jugadasdetalle.where(jugada_id: @jugada_id).last

    if ultimo && ultimo.r_player == 0 && ultimo.r_banker == 0

      ultimo.update!(r_player: tipo == "P" ? 1 : 0, r_banker: tipo == "B" ? 1 : 0)
      @detalle = ultimo
    else
      # No hay slot del PRC — insertar nuevo registro (primeros movimientos)
      @detalle = Jugadasdetalle.new(
        jugada_id: @jugada_id,
        r_player:  tipo == "P" ? 1 : 0,
        r_banker:  tipo == "B" ? 1 : 0
      )
      unless @detalle.save
        respond_to do |format|
          format.js   { render js: "alert('Error al guardar el movimiento.');" }
          format.json { render json: { status: "error", errors: @detalle.errors.full_messages }, status: :unprocessable_entity }
        end
        return
      end
    end

    # Correr el PRC con el id del registro actualizado/insertado
    ejecutar_prc_calculo_automatico(@detalle.id)
    @jugada = Jugada.for_user_list(current_user).find(@jugada_id)

    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugada_id)
    @nuevo_detalle     = @detalle

    respond_to do |format|
      format.js
      format.json { render json: { status: "ok", id: @detalle.id, total: @total_movimientos } }
    end
  end

  def undo
    # Limitar undo a 2 para usuarios no-admin
    unless is_sygma
      if undo_count_for_jugada >= 2
        respond_to do |format|
          format.js   { render js: "alert('#{I18n.t(:undo_limit_reached)}');" }
          format.json { render json: { status: 'error', message: I18n.t(:undo_limit_reached) }, status: :forbidden }
        end
        return
      end
      increment_undo_count_for_jugada
    end

    # Borrar el slot del PRC (último registro con r_player=0, r_banker=0)
    slot_prc = Jugadasdetalle
                 .where(jugada_id: @jugada_id)
                 .order(id: :desc)
                 .first
    ActiveRecord::Base.connection.execute("CALL prc_reversion_automatico(#{slot_prc.id.to_i})")
    slot_prc.destroy if slot_prc
=begin
    # Borrar el último movimiento confirmado por el usuario
    ultimo = Jugadasdetalle
               .where(jugada_id: @jugada_id)
               .where("r_player = 1 OR r_banker = 1")
               .order(id: :desc)
               .first
    ultimo.destroy if ultimo
=end
    @jugada = Jugada.for_user_list(current_user).find(@jugada_id)

    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugada_id)
    @undo_count        = undo_count_for_jugada

    respond_to do |format|
      format.js
      format.json { render json: { status: "ok", total: @total_movimientos, undo_count: @undo_count } }
    end
  end

  def reset
    # Solo administradores (geintac == 'S') pueden limpiar la sesión
    unless is_sygma
      respond_to do |format|
        format.js   { render js: "alert('#{I18n.t(:clear_session_admin_only)}');" }
        format.json { render json: { status: 'error', message: I18n.t(:clear_session_admin_only) }, status: :forbidden }
      end
      return
    end

    # Eliminar todos los registros asociados a esta jugada
    Jugadasdetalle.where(jugada_id: @jugada_id).delete_all
    @jugada = Jugada.for_user_list(current_user).find(@jugada_id)
    @jugada.update(protocoloix: 'N', protocolodx: 'N', controlesp: 0)
    @jugada = Jugada.for_user_list(current_user).find(@jugada_id)

    @jugadasdetalles   = []
    @total_movimientos = 0
    @proximo_bet       = "No Bet"

    respond_to do |format|
      format.js { render 'undo' }
      format.json { render json: { status: "ok", total: 0 } }
    end
  end

  # Marca jugada CERRADA sin recargar; UI bloquea P/B/undo/clear/finish vía finish.js.erb + jdLockPlayControls.
  def finish
    @jugada = Jugada.for_user_list(current_user).find(@jugada_id)

    unless @jugada.estado.to_s.upcase == 'PENDIENTE'
      respond_to do |format|
        format.js   { render :finish }
        format.json { render json: { status: 'ok', already_closed: true } }
      end
      return
    end

    unless @jugada.update(estado: 'CERRADA')
      msg = @jugada.errors.full_messages.to_sentence.presence || 'Error'
      respond_to do |format|
        format.js   { render js: "alert(#{msg.to_json});" }
        format.json { render json: { status: 'error', errors: @jugada.errors.full_messages }, status: :unprocessable_entity }
      end
      return
    end

    respond_to do |format|
      format.js   { render :finish }
      format.json { render json: { status: 'ok' } }
    end
  end

  # Botón especial (solo perfiles con permiso 'activarzapatos'): reabre una jugada
  # CERRADA, dejándola nuevamente PENDIENTE para poder seguir jugando este zapato.
  def activar_zapatos
    unless is_auth_c('activarzapatos')
      redirect_to new_jugadasdetalle_path(jugada_id: params[:jugada_id]), alert: I18n.t(:no_tiene_acceso_jugada)
      return
    end

    @jugada = Jugada.for_user_list(current_user).find(@jugada_id)
    @jugada.update(estado: 'PENDIENTE')

    redirect_to new_jugadasdetalle_path(jugada_id: params[:jugada_id]), notice: I18n.t(:zapato_reactivado)
  end

  def index
    @jugadasdetalles   = Jugadasdetalle.jugadas(@jugada_id)
    @total_movimientos = @jugadasdetalles.count
    @proximo_bet       = calcular_proximo_bet(@jugada_id)

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @jugadasdetalles }
    end
  end

  private

  def set_jugada_id
    # Acepta UUID o id integer en la URL. Internamente seguimos usando el integer.
    raw = params[:jugada_id].to_s
    if raw.blank?
      @jugada_id = 0
    elsif raw =~ /\A\d+\z/
      @jugada_id = raw.to_i
    else
      jugada = Jugada.find_by(uuid: raw)
      @jugada_id = jugada ? jugada.id : 0
    end
  end

  def ejecutar_prc_calculo_automatico(jugada_detalle_id)
    ActiveRecord::Base.connection.execute("CALL prc_calculo_automatico(#{jugada_detalle_id.to_i})")
  rescue => e
    Rails.logger.error "Error ejecutando prc_calculo_automatico: #{e.message}"
  end

  # Lee el slot que el PRC dejó (r_player=0, r_banker=0, orden máximo)
  # Retorna "P", "B" o "No Bet" según player1/banquer1
  def calcular_proximo_bet(jugada_id)
    Jugada.for_user_list(current_user).find(jugada_id).siguiente2.to_s
  end

  def authorize_jugada_acceso
    if @jugada_id.blank? || @jugada_id.to_i <= 0
      redirect_to root_path, alert: I18n.t(:jugada_no_valida)
      return
    end

    unless Jugada.for_user_list(current_user).exists?(id: @jugada_id)
      redirect_to root_path, alert: I18n.t(:no_tiene_acceso_jugada)
      return
    end

    return unless ensure_persona_solo_jugada_pendiente
  end

  # tipoconsulta PERSONA: no puede abrir otra jugada (IDOR) por URL; solo la sesión PENDIENTE activa.
  def ensure_persona_solo_jugada_pendiente
    return true unless current_user.tipoconsulta.to_s == "PERSONA"

    pend = Jugada.primera_pendiente_para(current_user)

    if pend.present?
      if pend.id != @jugada_id.to_i
        correcta = new_jugadasdetalle_path(jugada_id: pend.to_param)
        denegar_acceso_baccarat_persona(
          correcta,
          I18n.t(:solo_puede_acceder_jugada_pendiente)
        )
        return false
      end
      return true
    end

    # Sin PENDIENTE: permitir solo finish idempotente sobre jugada propia (tras cerrar, mismo POST no redirige).
    if action_name == 'finish' && Jugada.for_user_list(current_user).exists?(id: @jugada_id.to_i)
      return true
    end

    denegar_acceso_baccarat_persona(
      jugadas_path,
      I18n.t(:no_tiene_sesion_pendiente)
    )
    false
  end

  def denegar_acceso_baccarat_persona(redirect_path, message)
    respond_to do |format|
      format.html { redirect_to redirect_path, alert: message }
      format.js do
        render js: "alert(#{message.to_json}); window.location.replace(#{redirect_path.to_json});"
      end
      format.json { render json: { error: message, redirect: redirect_path }, status: :forbidden }
    end
  end

  def set_layout
    'viewspecial'
  end

  # ── Tracking de undos por jugada (para límite de no-admins) ─────────────────
  UNDO_MAX_NON_ADMIN = 2

  def undo_count_for_jugada
    (session[:undo_counts] ||= {})[@jugada_id.to_s].to_i
  end

  def increment_undo_count_for_jugada
    session[:undo_counts] ||= {}
    session[:undo_counts][@jugada_id.to_s] = undo_count_for_jugada + 1
  end

  def block_unless_pendiente
    jugada = Jugada.for_user_list(current_user).find(@jugada_id)
    return if jugada.estado.to_s.upcase == 'PENDIENTE'

    respond_to do |format|
      # Sin alert: UI debe bloquearse vía jdLockPlayControls tras reload de estado; noop por si race.
      format.js   { render js: '// jugada no PENDIENTE' }
      format.json { render json: { status: 'error', message: 'Jugada no PENDIENTE' }, status: :forbidden }
    end
  end
end
