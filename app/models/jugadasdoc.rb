class Jugadasdoc < ApplicationRecord
  self.table_name = 'jugadasdocs'

  belongs_to :jugada

  has_attached_file :documento
  validates_attachment_presence :documento, message: I18n.t(:usersdoc_file_required)
  validates_attachment_size :documento, less_than: 10.megabytes, message: I18n.t(:usersdoc_file_too_large)
  validates_attachment_content_type :documento,
    content_type: [
      'application/pdf',
      'image/jpeg', 'image/png', 'image/gif',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    ],
    message: I18n.t(:usersdoc_file_invalid_type)

  validates :descripcion, presence: true
end
