class Infgrupo < ApplicationRecord
  self.table_name = 'infgrupos'

  has_many :usersreportes
end
