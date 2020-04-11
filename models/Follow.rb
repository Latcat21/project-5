class Follow < ActiveRecord::Base
has_many :colleges
has_many :players

validates_uniqueness_of :player_id
validates_uniqueness_of :college_id

end