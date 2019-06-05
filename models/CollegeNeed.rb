class CollegeNeed < ActiveRecord::Base
  belongs_to :college
  belongs_to :position

  
end