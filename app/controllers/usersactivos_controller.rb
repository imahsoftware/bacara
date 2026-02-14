class UsersactivosController < ApplicationController
  before_action :checkaccess

  def checkaccess
    return is_permit('admin/usersactivos')
  end

  def index
    @q = User.where(sesion: true).ransack(params[:q])
    @usersactivos = @q.result.paginate(:page => params[:page], :per_page => 10).order(current_sign_in_at: :desc)
  end

  def cerrarsesion
    @user = User.find(params[:id])
    @user.sesion = false
    @user.save
    respond_to do |format|
      format.html { redirect_to usersactivos_path, notice: 'Se desactivo la sesión' }
      format.json { head :no_content }
    end
  end
end
