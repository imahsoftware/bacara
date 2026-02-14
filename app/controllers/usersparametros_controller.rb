class UsersparametrosController < ApplicationController
  before_action :set_usersparametros, only: [:edit, :update, :destroy, :new, :create]

  def show
    @user = User.find(params[:user_id])
    @usersparametro = Usersparametro.find(params[:id]) if params[:id]
    respond_to { |format| format.js }
  end

  def new
    @active_record = Usersparametro.find(params[:active_id]) if params[:active_id].present?
    @user = User.find(params[:user_id])
    @usersparametro = Usersparametro.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Usersparametro.find(params[:active_id]) if params[:active_id].present?
    @usersparametro = Usersparametro.find(params[:id])
    @user = @usersparametro.user
    respond_to { |format| format.js }
  end

  def create
    @user = User.find(params[:user_id])
    @usersparametro = Usersparametro.new(usersparametro_params)
    @usersparametro.user_id = @user.id
    respond_to do |format|
      if @usersparametro.save
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @usersparametro } }
      end
    end
  end

  def update
    @usersparametro = Usersparametro.find(params[:id])
    @user = @usersparametro.user
    respond_to do |format|
      if @usersparametro.update(usersparametro_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @usersparametro } }
      end
    end
  end

  def destroy
    @usersparametro.destroy
    flash['success'] = 'Eliminado correctamente'
  end

  private

  def set_usersparametros
    @user = User.find(params[:user_id])
    @usersparametro = Usersparametro.find(params[:id]) if params[:id]
  end

  def usersparametro_params
    params.require(:usersparametro).permit!
  end
end
