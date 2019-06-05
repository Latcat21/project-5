class PlayerPosition < ActiveRecord::Base
  belongs_to :players
  has_many :positions
end