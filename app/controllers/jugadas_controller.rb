class JugadasController < ApplicationController
  before_action :set_jugada, only: [:show, :edit, :update, :destroy]

  layout :set_layout
  before_action :checkaccess

  def checkaccess
    return true if current_user.tipoconsulta.to_s == 'PERSONA'
    return is_permit('jugadas')
  end

  def index
    @jugadas_base = Jugada.for_user_list(current_user)
    @q = @jugadas_base.ransack(params[:q])
    @jugadas = @q.result.paginate(page: params[:page], per_page: 10)
    @persona_bloquea_nueva_jugada = Jugada.persona_tiene_jugada_abierta?(current_user)

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
        format.js { render js: "alert('Debe finalizar todas sus jugadas antes de crear una nueva.');" }
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
        format.js { render js: "alert('Debe finalizar todas sus jugadas antes de crear una nueva.');" }
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
      flash['success'] = "Eliminado con exito"
      format.js { render inline: "location.reload();" }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_jugada
    @jugada = Jugada.for_user_list(current_user).find(params[:id])
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
