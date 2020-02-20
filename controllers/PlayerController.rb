class PlayerController < ApplicationController

  before do
    puts "before filter is running"
      if !session[:logged_in]
        session[:message] = {
        success: false,
        status: "neutral",
        message: "You must be logged in to do that."
      }
    redirect '/users/login'
    end
  end
  
  get '/' do
  @positions = Position.all
  erb :player_reg

end
post '/account' do
  new_player= Player.new
  new_player.name = params[:name]
  new_player.school_name = params[:school_name]
  new_player.state = params[:state]
  new_player.city = params[:city]
  new_player.height = params[:height]
  new_player.weight = params[:weight]
  new_player.stats = params[:stats]
  new_player.email = params[:email]
  new_player.user_id = session[:user_id]
  new_player.save
 # this is an array of id's
  player_position_id = params[:position]

  player_position_id.each do |position_id|
  new_player_position = PlayerPosition.new
  new_player_position.player_id = new_player.id
  new_player_position.position_id = position_id
  new_player_position.save
  end
  redirect "/players/account"
end

get '/account' do
  user = User.find_by({:id => session[:user_id]})
  @player = Player.find_by({:user_id => session[:user_id]})
  @positions = @player.positions
  @user_id = user.id

 @messages = Message.where :user_id => params[:id]
 

  erb :player_home
 
end

get '/matching-colleges' do
  @player = Player.find_by({:user_id => session[:user_id]})
  #finds this players positions
  @positions = @player.positions
  #looping over college positions... I used flat map to get a single array instead of an array of arrays
  @open_positions = @positions.flat_map do |position| 
    position.colleges
  end
  #This makes it so there are no dupplicates
   @open_positions = @open_positions.uniq()
  erb :college_match
end

get '/college/:id' do
  @college = College.find params[:id]
  erb :college_show

end

post '/college/:id/message' do
  logged_in_user = User.find_by ({ :username => session[:username] })

  new_message = Message.new
  new_message.content = params[:content]
  new_message.from_id = logged_in_user.id
  new_message.user_id = params[:id]
  new_message.save

  session[:message] = {
    success: true,
    status: "Good",
    message: "Your message has been sent"
    }
    
    redirect "/players/account"
end


get '/:id/edit' do
  @positions = Position.all
  @player = Player.find params[:id]
  erb :player_edit
end

put '/account/:id' do
  updated_player = Player.find params[:id]
  updated_player.name = params[:name]
  updated_player.school_name = params[:school_name]
  updated_player.state = params[:state]
  updated_player.city = params[:city]
  updated_player.height = params[:height]
  updated_player.weight = params[:weight]
  updated_player.stats = params[:stats]
  updated_player.save
  # delete all player_positions associated with this player 
  @player = Player.find_by({:user_id => session[:user_id]})
  
  found_relations = @player.player_positions

  found_relations.each do |relation| 
    relation.destroy
  end
  
  #grabbing position Id's to loop over
  player_position_id = params[:position]
    
  player_position_id.each do |position_id|
    new_player_position = PlayerPosition.new
    new_player_position.player_id = updated_player.id
    new_player_position.position_id = position_id
    new_player_position.save
  end
    redirect "/players/account"
  end
end