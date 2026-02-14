class Usershorario < ApplicationRecord
  belongs_to :usersfecha

  def name
    self.horario rescue nil
  end
end
