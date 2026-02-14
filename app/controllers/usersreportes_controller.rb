class UsersreportesController < ApplicationController
  before_action :set_usersreportes, only: [:show, :edit, :update, :destroy, :new, :create, :all_usersreportes]
  before_action :all_usersreportes, only: [:create, :update, :destroy]

  layout :determine_layout

  def index
    @user   = User.find(current_user)
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Usersreporte.find(params[:active_id]) if params[:active_id].present?
    @user = User.find(params[:user_id])
    @usersreporte = Usersreporte.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Usersreporte.find(params[:active_id]) if params[:active_id].present?
    @usersreporte = Usersreporte.find(params[:id])
    @user = @usersreporte.user
    respond_to { |format| format.js }
  end

  def create
    @reportes = params[:usersreporte][:infgrupo_id].reject { |c| c.empty? }
    i = 0
    for i in 0..@reportes.count-1
      @user  = User.find(params[:user_id])
      @usersreporte = Usersreporte.new(usersreporte_params)
      @usersreporte.infgrupo_id = @reportes[i]
      @usersreporte.user_id = @user.id
      respond_to do |format|
        if @usersreporte.save
          format.js
        else
          format.js { render 'layouts/errors', locals: { object: @usersreporte } }
        end
      end
    end
  end

  def update
    @usersreporte = Usersreporte.find(params[:id])
    @user = @usersreporte.user
    respond_to do |format|
      if @usersreporte.update(usersreporte_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @usersreporte } }
      end
    end
  end

  def destroy
    @usersreporte.destroy
    flash['success'] = 'Eliminado correctamente'
  end

  private

  def all_usersreportes
    @usersreportes = @user.usersreportes.order("created_at asc")
  end

  def set_usersreportes
    @user = User.find(params[:user_id])
    @usersreporte = Usersreporte.find(params[:id]) if params[:id]
  end

  def usersreporte_params
    params.require(:usersreporte).permit!
  end

  def determine_layout
    if ['index'].include?(action_name)
      #"application_menu"
      "application_admin"
    elsif ['datos'].include?(action_name)
      "without_layout"
    else
      "application_admin"
    end
  end
end
