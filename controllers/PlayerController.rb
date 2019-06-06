class PlayerController < ApplicationController
  get '/' do
  @positions = Position.all
  erb :player_reg

end
post '/' do

  puts "here are the params"
  pp params

  new_player= Player.new
  new_player.name = params[:name]
  new_player.school_name = params[:school_name]
  new_player.location = params[:location]
  new_player.height = params[:height]
  new_player.weight = params[:weight]
  new_player.stats = params[:stats]

  new_player.save

 


  # this is an array of id's
 player_position_id = params[:position]


  # loop over player_postiion_ids
  player_position_id.each do |position_id|

    new_player_position = PlayerPosition.new

    new_player_position.player_id = new_player.id

    new_player_position.position_id = position_id
    
    new_player_position.save

  end

  "check terminal"

end

get '/player-results' do
  erb :player_results

end









end