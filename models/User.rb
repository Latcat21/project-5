class User < ActiveRecord::Base
  has_secure_password
  has_many :Player
  has_many :college
end