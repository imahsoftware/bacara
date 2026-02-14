class Usersfecha < ApplicationRecord
  belongs_to :helenasuser
  has_many :usershorarios, :dependent =>:destroy
  after_create :despuesdecrear

  def name
    self.fecha.to_s rescue nil
  end

  def despuesdecrear
    if self.id
      if Helenasuser.exists?(["user_id = #{self.user_id}"]) == false
        u = Helenasuser.new
        u.id =self.user_id
        u.user_id = self.user_id
        u.save
      end
      ActiveRecord::Base.connection.execute("update usersfechas set helenasuser_id = #{self.user_id} where id = #{self.id}")
      ProcesoJob.perform_now("prc_agendasprogramacion(#{self.id}, #{self.cantidad.to_i}, '#{self.hora_inicio.to_s}', '#{self.hora_fin.to_s}', #{self.intervalo.to_i})")
    end
  end

end
