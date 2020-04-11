class Player <  ActiveRecord::Base
    belongs_to :user
    has_many :player_positions
    has_many( :positions, {:through => :player_positions} )
    has_one :state
    has_many :relations
  
end