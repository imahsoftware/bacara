class LoginActivity < ActiveRecord::Base
  self.table_name = 'login_activities'
  belongs_to :user, polymorphic: true, optional: true
end
