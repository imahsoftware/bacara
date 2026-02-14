class UsersvehiculosController < ApplicationController
  before_action :set_usersvehiculo, only: [:show, :destroy]

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Usersvehiculo.find(params[:active_id]) if params[:active_id].present?
    @user = User.find(params[:user_id])
    @usersvehiculo = Usersvehiculo.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Usersvehiculo.find(params[:active_id]) if params[:active_id].present?
    @usersvehiculo = Usersvehiculo.find(params[:id])
    @user = @usersvehiculo.user
    respond_to { |format| format.js }
  end

  def create
    @user  = User.find(params[:user_id])
    @usersvehiculo = Usersvehiculo.new(usersvehiculo_params)
    @usersvehiculo.user_id = @user.id
    respond_to do |format|
      if @usersvehiculo.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @usersvehiculo } }
      end
    end
  end

  def update
    @usersvehiculo = Usersvehiculo.find(params[:id])
    @user = @usersvehiculo.user
    respond_to do |format|
      if @usersvehiculo.update(usersvehiculo_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @usersvehiculo } }
      end
    end
  end

  def destroy
    @usersvehiculo.destroy
    flash['success'] = 'Eliminado correctamente'
  end

  private
    def set_usersvehiculo
      @user = User.find(params[:user_id])
      @usersvehiculo = Usersvehiculo.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def usersvehiculo_params
      params.require(:usersvehiculo).permit(:user_id, :portafoliosvehiculo_id)
    end
end
