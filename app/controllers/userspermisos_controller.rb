class UserspermisosController < ApplicationController
  before_action :set_userspermisos, only: [:edit, :update, :destroy, :new, :create, :all_userspermisos]
  before_action :all_userspermisos, only: [:index, :create, :update, :destroy]

  def show
    @user = User.find(params[:user_id])
    @userspermiso = Userspermiso.find(params[:id]) if params[:id]
    respond_to { |format| format.js }
  end

  def new
    @active_record = Userspermiso.find(params[:active_id]) if params[:active_id].present?
    @user = User.find(params[:user_id])
    @userspermiso = Userspermiso.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Userspermiso.find(params[:active_id]) if params[:active_id].present?
    @userspermiso = Userspermiso.find(params[:id])
    @user = @userspermiso.user
    respond_to { |format| format.js }
  end

  def create
    @permisos = params[:userspermiso][:objeto_id].reject { |c| c.empty? }
    i = 0
    for i in 0..@permisos.count-1
      @user  = User.find(params[:user_id])
      @userspermiso = Userspermiso.new(userspermiso_params)
      @userspermiso.objeto_id = @permisos[i]
      @userspermiso.user_id = @user.id
      @userspermiso.crea = params[:userspermiso][:crea]
      @userspermiso.actualiza = params[:userspermiso][:actualiza]
      @userspermiso.elimina = params[:userspermiso][:elimina]
      if @permisos[i].to_i == 12132
        @user.etapa = 'GE'
        @user.save
      elsif @permisos[i].to_i == 12452
        @user.estapaedu = 'ACTIVA'
        @user.save
      end
      respond_to do |format|
        if @userspermiso.save
          format.js
        else
          format.js { render 'layouts/errors', locals: { object: @userspermiso } }
        end
      end
    end
  end

  def update
    @userspermiso = Userspermiso.find(params[:id])
    @user = @userspermiso.user
    respond_to do |format|
      if @userspermiso.update(userspermiso_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @userspermiso } }
      end
    end
  end

  def destroy
    if @userspermiso.objeto_id == 12132
      @user.etapa = 'A'
      @user.save
    elsif @userspermiso.objeto_id == 12452
        @user.estapaedu = 'INACTIVA'
        @user.save
    end
    @userspermiso.destroy
    flash['success'] = 'Eliminado correctamente'
  end

  private

  def all_userspermisos
    @userspermisos = @user.userspermisos.order("created_at asc")
  end

  def set_userspermisos
    @user = User.find(params[:user_id])
    @userspermiso = Userspermiso.find(params[:id]) if params[:id]
  end

  def userspermiso_params
    params.require(:userspermiso).permit!
  end
end
