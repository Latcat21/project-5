require 'sinatra/base'
require './controllers/ApplicationController'
require './controllers/UserController'

require './controllers/CollegeController'
require './controllers/PlayerController'


require './models/User'
require './models/College'
require './models/Player'
require './models/Position'
require './models/CollegeNeed'
require './models/PlayerPosition'


map ('/') {
  run ApplicationController
}
map ('/users') {
  run UserController
}
map ('/college-account') {
  run CollegeController
}
map ('/player-account') {
  run PlayerController
}




