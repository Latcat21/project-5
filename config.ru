require 'sinatra/base'
require 'sinatra/cross_origin'
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
require './models/Message'
require './models/Reply'
require './models/State'
require './models/Relation'

require 'sass/plugin/rack'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

map ('/') {
  run ApplicationController
}
map ('/users') {
  run UserController
}
map ('/colleges') {
  run CollegeController
}
map ('/players') {
  run PlayerController
}