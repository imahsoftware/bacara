class UsersfechasController < ApplicationController
  before_action :set_usersfecha, only: [:show, :destroy]

  layout :determine_layout

  def index
    user = User.find(params[:user_id])
    @usersfechas = user.usersfechas.all
  end

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Usersfecha.find(params[:active_id]) if params[:active_id].present?
    @user = User.find(params[:user_id])
    @usersfecha = Usersfecha.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Usersfecha.find(params[:active_id]) if params[:active_id].present?
    @usersfecha = Usersfecha.find(params[:id])
    @user = @usersfecha.user
    respond_to { |format| format.js }
  end

  def create
    @user  = User.find(params[:user_id])
    @usersfecha = Usersfecha.new(usersfecha_params)
    @usersfecha.user_id = @user.id
    respond_to do |format|
      if @usersfecha.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @usersfecha } }
      end
    end
  end

  def update
    @usersfecha = Usersfecha.new
    usersfecha = Usersfecha.find(params[:id])
    #usersfecha.user_id = is_admin
    @user = usersfecha.user
    ok = usersfecha.update(usersfecha_params)
    flash[:usersfecha] = ok ? "Actualizado con Exito" : "Se produjo un error al actualizar el registro"
    respond_to do |format|
      format.js { render action: "usersfechas" }
    end
  end

  def destroy
    usersfecha = Usersfecha.find(params[:id])
    @user = usersfecha.user
    @usersfecha = Usersfecha.new
    usersfecha.destroy
    flash[:usersfecha] = I18n.t(:notice_elimina_msj)
    respond_to do |format|
      format.js { render action: "usersfechas" }
    end
  end

  private

    def determine_layout
      if [''].include?(action_name)
        "application_admin"
      end
    end

    def set_usersfecha
      @user = User.find(params[:user_id])
      @usersfecha = Usersfecha.find(params[:id]) if params[:id]
    end

    def usersfecha_params
      params.require(:usersfecha).permit!
    end
end
