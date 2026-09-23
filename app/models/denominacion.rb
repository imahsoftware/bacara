class Denominacion < ApplicationRecord
  has_many :jugadas

  validates :nombre, presence: true
  validates :codigo, presence: true, uniqueness: { case_sensitive: false }

  scope :activas, -> { where(estado: 'ACTIVO').order(:nombre) }

  before_validation { self.codigo = codigo.to_s.strip.upcase if codigo.present? }

  def activo?
    estado.to_s.upcase == 'ACTIVO'
  end

  # "$ (COP) Peso Colombiano" — usado en los selects de administración.
  def etiqueta
    "#{simbolo} (#{codigo}) #{nombre}".strip
  end
end
