class MenusController < ApplicationController
  layout :set_layout
  # before_action :verificardatos, if: :user_signed_in?
  before_action :validatesession

  require 'rqrcode'

  def index
  end

  private

  def set_layout
    if ['PERSONA', 'METRO'].include?(User.find(is_admin).tipoconsulta.to_s)
      'application_admin'
    else
      'application_admin'
    end
  end
end
