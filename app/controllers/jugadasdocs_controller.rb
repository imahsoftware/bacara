class JugadasdocsController < ApplicationController
  before_action :set_jugada
  before_action :set_jugadasdoc, only: [:destroy]
  layout 'viewspecial'

  def create
    @jugadasdoc = @jugada.jugadasdocs.build(jugadasdoc_params)
    if @jugadasdoc.save
      flash[:notice] = I18n.t(:usersdoc_uploaded_successfully)
    else
      errors = @jugadasdoc.errors.full_messages.join(', ')
      Rails.logger.error "[JugadasdocsController#create] Save failed for jugada #{@jugada.id}: #{errors}"
      flash[:alert] = errors.presence || 'No se pudo guardar el documento.'
    end
    redirect_to new_jugadasdetalle_path(jugada_id: @jugada.to_param)
  end

  def destroy
    @jugadasdoc.destroy
    flash[:notice] = I18n.t(:usersdoc_deleted_successfully)
    redirect_to new_jugadasdetalle_path(jugada_id: @jugada.to_param)
  end

  private

  def set_jugada
    @jugada = Jugada.find_by_param!(params[:jugada_id])
  end

  def set_jugadasdoc
    @jugadasdoc = @jugada.jugadasdocs.find(params[:id])
  end

  def jugadasdoc_params
    params.require(:jugadasdoc).permit(:descripcion, :documento)
  end
end
