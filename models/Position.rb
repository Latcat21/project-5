class Position < ActiveRecord::Base
  has_many :college_needs
  has_many(:colleges, {:through => :college_needs})
  has_many :player_positions
  has_many(:players, {:through => :player_positions})
end