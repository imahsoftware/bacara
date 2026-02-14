class Usersregistrado < ApplicationRecord
  validates :nombres, :email, :password, :confirma_password, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :email, uniqueness: true

  validate :validapassword

  def validapassword
    if self.password.to_s != self.confirma_password.to_s
      errors.add :password, "* La contraseña no coinciden"
      errors.add :confirma_password, "* La contraseña no coinciden"
    end
  end
end
