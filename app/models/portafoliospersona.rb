class Portafoliospersona < ApplicationRecord
  belongs_to :portafolio
  belongs_to :persona

  validates_presence_of :persona_id

  after_save :despuesdeguardar

  def despuesdeguardar
    persona = Persona.find(self.persona_id)
    persona.portafolio_id = self.portafolio_id
    persona.save(validate: false)
    user = User.find(persona.user_id)
    user.portafolio_id = self.portafolio_id
    user.save(validate: false)
  end
end
