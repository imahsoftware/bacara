class UsershorariosController < ApplicationController
  before_action :set_usershorario, only: [:show, :edit, :update, :destroy, :act, :bact]
#  layout :determine_layout

  def index
    @usersfecha = Usersfecha.find(params[:id])
    @usershorarios = @usersfecha.usershorarios.all.order("id asc")
  end

  def act
    @usershorario.estado = 'ACTIVO'
    @usershorario.save
    flash[:notice] = I18n.t(:activated_label)
    redirect_to usershorarios_path(:id =>@usershorario.usersfecha_id)
  end

  def bact
    @usershorario.estado = 'INACTIVO'
    @usershorario.save
    flash[:notice] = I18n.t(:inactivated_label)
    redirect_to usershorarios_path(:id =>@usershorario.usersfecha_id)
  end

  def new
    @usershorario = Usershorario.new
  end

  def edit
  end

  def create
    @usershorario = Usershorario.new(usershorario_params)

    respond_to do |format|
      if @usershorario.save
        format.html { redirect_to(@usershorario, :notice => 'Usershorario was successfully created.') }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @usershorario.update(usershorario_params)
        format.html { redirect_to(@usershorario, :notice => 'Usershorario was successfully updated.') }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @usershorario.destroy
    respond_to do |format|
      format.html { redirect_to(usershorarios_url) }
    end
  end

  private

    def set_usershorario
      @usershorario = Usershorario.find(params[:id])
    end

    def usershorario_params
      params.require(:usershorario).permit!
    end
end
