class UsersvisitasController < ApplicationController
  before_action :set_usersvisitas, only: [:edit, :update, :destroy, :new, :create, :all_usersvisitas]
  before_action :all_usersvisitas, only: [:index, :create, :update, :destroy]

  def show
    @user = User.find(params[:user_id])
    @usersvisita = Usersvisita.find(params[:id]) if params[:id]
    respond_to { |format| format.js }
  end

  def new
    @active_record = Usersvisita.find(params[:active_id]) if params[:active_id].present?
    @user = User.find(params[:user_id])
    @usersvisita = Usersvisita.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Usersvisita.find(params[:active_id]) if params[:active_id].present?
    @usersvisita = Usersvisita.find(params[:id])
    @user = @usersvisita.user
    respond_to { |format| format.js }
  end

  def searchUsuarios
    @users = User.where("tipoconsulta in ('TODO','SUPERVISOR', 'GESTION', 'GESTION', 'ADMINISTRADOR') and (nombre LIKE ? or identificacion = ?)", "%#{replacespace(params[:q]).upcase}%", "#{replacespace(params[:q]).upcase}").limit(10)
    respond_to do |format|
      format.json { render json: @users.map { |p| { id: p.id, name: "#{p.nombrecompleto}" } } }
    end
  end

  def create
    @user = User.find(params[:user_id])
    @usersvisita = Usersvisita.new(usersvisita_params)
    @usersvisita.user_id = @user.id
    respond_to do |format|
      if @usersvisita.save
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @usersvisita } }
      end
    end
  end

  def update
    @usersvisita = Usersvisita.find(params[:id])
    @user = @usersvisita.user
    respond_to do |format|
      if @usersvisita.update(usersvisita_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @usersvisita } }
      end
    end
  end

  def destroy
    @usersvisita.destroy
    flash['success'] = 'Eliminado correctamente'
  end

  private

  def all_usersvisitas
    @usersvisitas = @user.usersvisitas.order("created_at asc")
  end

  def set_usersvisitas
    @user = User.find(params[:user_id])
    @usersvisita = Usersvisita.find(params[:id]) if params[:id]
  end

  def usersvisita_params
    params.require(:usersvisita).permit!
  end
end
