class UsersportafoliosController < ApplicationController
  before_action :set_usersportafolio, only: [:show, :destroy]

  def show
    respond_to { |format| format.js }
  end

  def new
    @active_record = Usersportafolio.find(params[:active_id]) if params[:active_id].present?
    @user = User.find(params[:user_id])
    @usersportafolio = Usersportafolio.new
    respond_to { |format| format.js }
  end

  def edit
    @active_record = Usersportafolio.find(params[:active_id]) if params[:active_id].present?
    @usersportafolio = Usersportafolio.find(params[:id])
    @user = @usersportafolio.user
    respond_to { |format| format.js }
  end

  def create
    @user  = User.find(params[:user_id])
    @usersportafolio = Usersportafolio.new(usersportafolio_params)
    @usersportafolio.user_id = @user.id
    respond_to do |format|
      if @usersportafolio.save
        flash[:notice] = "#{t :notice_crea_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @usersportafolio } }
      end
    end
  end

  def update
    @usersportafolio = Usersportafolio.find(params[:id])
    @user = @usersportafolio.user
    respond_to do |format|
      if @usersportafolio.update(usersportafolio_params)
        flash[:notice] = "#{t :notice_actualiza_msj}"
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @usersportafolio } }
      end
    end
  end

  def destroy
    @usersportafolio.destroy
    flash['success'] = 'Eliminado correctamente'
  end

  private
    def set_usersportafolio
      @user = User.find(params[:user_id])
      @usersportafolio = Usersportafolio.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def usersportafolio_params
      params.require(:usersportafolio).permit(:user_id, :portafolio_id)
    end
end
