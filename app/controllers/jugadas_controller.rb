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
    redirect_to new_jugadasdetalle_path(jugada_id: pend.id) and return if pend
  end

  def index
    @jugadas_base = Jugada.for_user_list(current_user)
    @jugadas = @jugadas_base.order(id: :desc).paginate(page: params[:page], per_page: 10)
    @persona_bloquea_nueva_jugada = Jugada.persona_tiene_jugada_abierta?(current_user)
    @persona_ultima_cerrada = Jugada.ultima_cerrada_para_nueva_shoe(current_user)

    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to { |format| format.js }
  end

  def new
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
    respond_to do |format|
      if @jugada.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js { render inline: "location.reload();" }
      else
        format.js { render 'layouts/errors', locals: { object: @jugada } }
      end
    end
  end

  # Solo PERSONA, desde baccarat (viewspecial): crea jugada y abre su detalle.
  def nueva_shoe
    unless current_user.tipoconsulta.to_s == 'PERSONA'
      redirect_to root_path, alert: I18n.t(:accion_no_permitida)
      return
    end

    from = Jugada.for_user_list(current_user).find_by(id: params[:from_jugada_id].to_i)
    if from.blank? || from.estado.to_s.upcase != 'CERRADA'
      redirect_back fallback_location: jugadas_path, alert: I18n.t(:solo_crear_jugada_cuando_cerrada)
      return
    end

    if Jugada.persona_tiene_jugada_abierta?(current_user)
      redirect_back fallback_location: new_jugadasdetalle_path(jugada_id: from.id), alert: I18n.t(:otra_jugada_pendiente)
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
      redirect_to new_jugadasdetalle_path(jugada_id: @jugada.id)
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
    @jugada = Jugada.for_user_list(current_user).find(params[:id])
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
