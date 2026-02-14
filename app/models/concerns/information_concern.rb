module InformationConcern
  extend ActiveSupport::Concern

  def descripcion_contrato
    Contrato.find(contrato_id).nombrecontrato
  rescue StandardError
    nil
  end

  def descripcion_user
    User.find(user_id).nombre
  rescue StandardError
    nil
  end
end
