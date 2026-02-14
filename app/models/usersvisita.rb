class Usersvisita < ApplicationRecord
  belongs_to :user

  validates_presence_of :user_asignado

  def descripcion_users
    return User.find(self.user_asignado).nombrecompleto rescue nil
  end
end
