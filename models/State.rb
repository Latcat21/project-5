class State < ActiveRecord::Base
  belongs_to :college
  belongs_to :player
end