class UserstemporalesController < ApplicationController
  before_action :set_userstemporal, only: [:show, :edit, :update, :destroy]

  layout :set_layout

  def new2
    @userstemporal = Userstemporal.new
  end

  def create2
    @userstemporal = Userstemporal.new(userstemporal_params)
    @userstemporal.user_id = is_admin
    respond_to do |format|
      if @userstemporal.save
        flash[:notice] = I18n.t(:notice_crea_msj)
        format.js
      else
        format.js { render 'layouts/errors', locals: { object: @userstemporal } }
      end
    end
  end

  private
  def set_layout
    if ['index', 'new', 'create', 'update'].include?(action_name)
      'blank'
    else
      'blank'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_userstemporal
    @userstemporal = Userstemporal.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def userstemporal_params
    params.require(:userstemporal).permit!
  end
end
