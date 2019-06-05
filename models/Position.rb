class Position < ActiveRecord::Base
  has_many :college_needs
  has_many(:colleges, {:through => :college_needs})

  


end