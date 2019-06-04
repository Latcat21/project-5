class Player < ActiveRecord::Base
  has_many :position, :through => :player_positions
end