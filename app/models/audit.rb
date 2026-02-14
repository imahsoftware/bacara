class Audit < Audited.audit_class
  belongs_to :user
  
  def self.default_scope
    includes(:user)
  end

  def self.default_sort
    descending
  end

end
