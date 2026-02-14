class ErrorsController < ApplicationController
  layout :determine_layout

  def not_found
    respond_to do |format|
      format.html { render status: 404 }
      format.png { render plain: 'Not Found', status: 404, content_type: 'text/plain' }
    end
  end

  def internal_server_error
    respond_to do |format|
      format.html { render status: 500 }
      format.png { render plain: 'Internal Server Error', status: 500, content_type: 'text/plain' }
      # Puedes agregar la lógica de envío de correo aquí si es necesario
    end
  end

  private

  def determine_layout
    "login"
  end
end
