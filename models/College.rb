class College < ActiveRecord::Base
  has_many :position, :through => :college_needs
end