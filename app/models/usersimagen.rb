class Usersimagen < ApplicationRecord
  belongs_to :user

  has_attached_file :usersimagen
  validates_presence_of :clase

  validates_attachment_presence :usersimagen, message: 'Debe seleccionar un archivo valido!!'
  #validates_attachment_content_type :usersimagen, :content_type => ['application/pdf'], :message => 'Solo puede cargar archivos en formato PDF!!'
  validates_attachment_size :usersimagen, less_than: 7000.kilobytes, message: 'El tamaño del archivo no puede ser superior a 7 Megabytes!!!'


end
