class College < ActiveRecord::Base
  has_many :college_needs
  has_many( :positions, {:through => :college_needs} )
  belongs_to :user
  has_one :state
end