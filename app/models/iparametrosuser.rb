class Iparametrosuser < ApplicationRecord
  belongs_to :iparametro
  belongs_to :user

  validates_presence_of :user_id
end
