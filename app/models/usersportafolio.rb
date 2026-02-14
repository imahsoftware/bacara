class Usersportafolio < ApplicationRecord
  belongs_to :user
  belongs_to :portafolio

  validates_uniqueness_of :portafolio_id, scope: :user_id

  validates :portafolio_id, presence: true
end
