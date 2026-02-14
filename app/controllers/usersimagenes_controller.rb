class UsersimagenesController < ApplicationController
  
  before_action :find_user_and_usersimagen, :except=>"destroy2"
  layout :determine_layout

  def index
    user = User.find(params[:user_id])
    @usersimagenes = user.usersimagenes.find(:all)
  end

  def new
    @usersimagen = Usersimagen.new
  end

  def create
    @usersimagen = Usersimagen.new(usersimagen_params)
    @usersimagen.user_id = @user.id
    respond_to do |format|
      if @usersimagen.save
        flash[:notice] = "Documento Cargado con Exito."
        format.html { redirect_to edit_user_path(@user) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @usersimagen = Usersimagen.find(params[:id])
    respond_to do |format|
      if @usersimagen.update(usersimagen_params)
        format.html { redirect_to user_usersimagenes_path(@user) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    usersimagen = Usersimagen.find(params[:id])
    @user = usersimagen.user
    @usersimagen = Usersimagen.new
    usersimagen.destroy
    render :update do |page|
      page.alert "Imah - Documento eliminado"
    end
  end

  def destroy2
    usersimagen = Usersimagen.find(params[:id])
    usersimagen.destroy
    flash[:notice] = "Documento Eliminado con Exito."
    redirect_to controller: "users", action: "edit", id: params[:user_id]
  end

  def find_user_and_usersimagen
    @user = User.find(params[:user_id])
    @usersimagen = Usersimagen.find(params[:id]) if params[:id]
  end

  private

    def determine_layout
      if ['buscarx','rptdatos','rptconsolidado'].include?(action_name)
        "informes"
      else
        "application_admin"
      end
    end

    def usersimagen_params
      params.require(:usersimagen).permit!
    end
end
