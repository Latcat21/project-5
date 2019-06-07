class PlayerController < ApplicationController
  get '/' do
  @positions = Position.all
  erb :player_reg

end
post '/account' do

  puts "here are the params"
  pp params

  new_player= Player.new
  new_player.name = params[:name]
  new_player.school_name = params[:school_name]
  new_player.location = params[:location]
  new_player.height = params[:height]
  new_player.weight = params[:weight]
  new_player.stats = params[:stats]
  new_player.user_id = session[:user_id]

  new_player.save

 


  # this is an array of id's
 player_position_id = params[:position]

#  if player_position_id.length > 2
#   session[:message] = {
#     success: false,
#     status: "bad",
#     message: "Sorry, you can only select 2 positions"
#   }
#   redirect('/players')
# end

  # loop over player_postiion_ids
  player_position_id.each do |position_id|

    

    
      new_player_position = PlayerPosition.new

      new_player_position.player_id = new_player.id
  
      new_player_position.position_id = position_id
      
      new_player_position.save

    
end
  redirect '/players/account'
end



get '/account' do

  # this is using a through table to get positions for a player
  @player = Player.find_by({:user_id => session[:user_id]})
  @positions = @player.positions


  erb :player_show

end

get '/matching-colleges' do

  @player = Player.find_by({:user_id => session[:user_id]})
  
  @positions = @player.positions

  # @position = @positions[0]
  #looping of college positions... I used flat map to get a single array instead of an array of arrays
   @open_positions = @positions.flat_map do |position| 
    position.colleges

   end

   #This makes it so there are no dupplicates
   @open_positions = @open_positions.uniq()


# get all the pos for this player


# I need to find out which colleges have open positions I play
# for each position i play -- 

#find  colleges  with a need that matches that position
# position .colleges hint hint

   erb :college_match

 end
end