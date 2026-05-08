class UsersdocsController < ApplicationController
  before_action :set_user
  before_action :set_usersdoc, only: [:destroy]
  layout 'application_admin'

  def create
    @usersdoc = @user.usersdocs.build(usersdoc_params)
    if @usersdoc.save
      flash[:notice] = I18n.t(:usersdoc_uploaded_successfully)
    else
      flash[:alert] = @usersdoc.errors.full_messages.join(', ')
    end
    redirect_to edit_user_path(etapa: 'A', id: @user.id)
  end

  def destroy
    @usersdoc.destroy
    flash[:notice] = I18n.t(:usersdoc_deleted_successfully)
    redirect_to edit_user_path(etapa: 'A', id: @user.id)
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_usersdoc
      @usersdoc = @user.usersdocs.find(params[:id])
    end

    def usersdoc_params
      params.require(:usersdoc).permit(:descripcion, :documento)
    end
end
