class Player <  ActiveRecord::Base
    has_many :player_positions
    has_many( :positions, {:through => :player_positions} )
end