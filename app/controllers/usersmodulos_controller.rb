class UsersmodulosController < ApplicationController
  before_action :set_usersmodulos, only: [:show, :edit, :update, :destroy, :new, :create, :all_usersmodulos]
  before_action :all_usersmodulos, only: [:create, :update, :destroy]

  layout :determine_layout

  def index
    @user   = User.find(current_user)
    #@modulos = Modulo.where(id: Usersmodulo.where(user_id: user).pluck(:modulo_id), grupo: @mod).order(:grupo)
  end

  def show
    respond_to { |format| format.js }
  end

  def menu
    @mod = ""
    user   = User.find(current_user)
    if params[:grupo].to_i == 1
      @mod = 'Gestion'
    elsif params[:grupo].to_i == 2
      @mod = 'Facturacion'
    elsif params[:grupo].to_i == 3
      @mod = 'Parametrizacion'
    elsif params[:grupo].to_i == 4
      @mod = 'Informes'
    elsif params[:grupo].to_i == 5
      @mod = 'Seguridad'
    else
      @mod = 'menu'
    end
    @modulos = Modulo.where(id: Usersmodulo.where(user_id: user).pluck(:modulo_id), grupo: @mod).order(:grupo)
  end

  def datos
    @user = User.find(params[:user_id])
  end

  def new
    @active_record = Usersmodulo.find(params[:active_id]) if params[:active_id].present?
    @user = User.find(params[:user_id])
    @usersmodulo = Usersmodulo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Usersmodulo.find(params[:active_id]) if params[:active_id].present?
    @usersmodulo = Usersmodulo.find(params[:id])
    @user = @usersmodulo.user
    respond_to { |format| format.js }
  end

  def create
    @modulos = params[:usersmodulo][:modulo_id].reject { |c| c.empty? }
    i = 0
    for i in 0..@modulos.count-1
      @user  = User.find(params[:user_id])
      @usersmodulo = Usersmodulo.new(usersmodulo_params)
      @usersmodulo.modulo_id = @modulos[i]
      @usersmodulo.user_id = @user.id
      respond_to do |format|
        if @usersmodulo.save
          format.js
        else
          format.js { render 'layouts/errors', locals: { object: @usersmodulo } }
        end
      end
    end
  end

  def update
    @usersmodulo = Usersmodulo.find(params[:id])
    @user = @usersmodulo.user
    respond_to do |format|
      if @usersmodulo.update(usersmodulo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @usersmodulo } }
      end
    end
  end

  def destroy
    @usersmodulo.destroy
    flash['success'] = 'Eliminado correctamente'
  end

  private

    def all_usersmodulos
      @usersmodulos = @user.usersmodulos.order("created_at asc")
    end

    def set_usersmodulos
      @user = User.find(params[:user_id])
      @usersmodulo = Usersmodulo.find(params[:id]) if params[:id]
    end

    def usersmodulo_params
      params.require(:usersmodulo).permit!
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
