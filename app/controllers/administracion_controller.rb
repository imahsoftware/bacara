# hola
class AdministracionController < ApplicationController
  before_action :checkaccess

  def checkaccess
    return is_permit('administracion/icons')

    return is_permit('administracion/index')
  end

  def index

  end

  def killjob

  end

  def icons
  end
end