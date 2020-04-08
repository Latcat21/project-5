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
  @states = State.all
  erb :player_reg

end

post '/account' do
  new_player= Player.new
  new_player.name = params[:name]
  new_player.school_name = params[:school_name]
  new_player.state_code = params[:state]
  new_player.city = params[:city]
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

  @messages = user.messages
  @sent_messages = Message.where("from_id = ?", session[:user_id])
  
  erb :player_home
end

get '/account/:id' do
  user = User.find_by({:id => session[:user_id]})
  @message = Message.find params[:id]
  message = Message.all

  @replies = user.replies
  erb :player_message
end

delete '/account/:id' do
  user = User.find_by({:id => session[:user_id]})
  message = Message.find params[:id]
  replies = message.replies

  replies.each  do |relation|
    relation.destroy
  end

  message_id = message.id

  message.destroy
  
  session[:message] = {
    success: true,
    status: "Good",
    message: "Message #{message_id} has been deleted"
    }

  redirect '/players/account'

end

post '/account/:id/reply' do
  logged_in_user = User.find_by ({ :username => session[:username] })
  message = Message.find params[:id]
  reply = Reply.new
  reply.content = params[:content]
  reply.message_id = message.id
  reply.user_id = logged_in_user.id
  reply.save

  session[:message] = {
    success: true,
    status: "Good",
    message: "Your replay has been sent"
    }
    redirect "/players/account"
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
  city_name = @college.city
  found_state = State.find_by({:id  => @college.state_code})

  puts 'the found state is'
  state = found_state[:code]

  def address(city_name, state)
    arr_city = city_name.split(' ')
    if arr_city.length > 1
      arr_city = arr_city.join('+')
      return arr_city + ',' + state
    elsif arr_city.length == 1  
      return  arr_city[0] + ',' + state
    end
  end	
  @modified = address(city_name, state)
  @other_user = @college.name

  school = @college.school_name

  uri = URI("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{school}&inputtype=textquery&&fields=formatted_address,name,rating,photos,price_level&&key=AIzaSyDjHCJerc_QTC2Kq1NtMEew4oGQJEBWqks")
    it = Net::HTTP.get(uri)
    parsed_it = JSON.parse it 
    @places = parsed_it["results"]
    @img = @places.first['rating']
    puts "---------------"
    puts @places
    puts'^^^^^^^^^^^place^^^^^^^^^^^^^^^^^^'

    puts "---------------"
    puts @places.first["name"]
    puts @places.first['formatted_address']
    puts @img
    puts "^^^^^^^^^^img^^^^^^^^^^^^^^^"


   


  erb :college_show

end

post '/college/:id/message' do
  logged_in_user = User.find_by ({ :username => session[:username] })
   
  college = College.find params[:id]
  new_message = Message.new
  new_message.content = params[:content]
  new_message.title = params[:title]
  new_message.from_id = logged_in_user.id
  new_message.user_id = college.user.id
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