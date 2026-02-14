# app/models/notificacionesplataforma.rb
class Notificacionesplataforma < ApplicationRecord
  belongs_to :user

  scope :no_leidas, -> { where(leida: false) }
  scope :recientes, -> { order(created_at: :desc) }

  validates :mensaje, presence: true

  def marcar_como_leida
    update(leida: true)
  end
end
