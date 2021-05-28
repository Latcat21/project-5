class PlayerController < ApplicationController

  before do
   if !session[:logged_in] || session[:user_type] != 'player'
        session[:message] = {
        success: false,
        status: "neutral",
        message: "You must be logged in to do that."
      }
    redirect '/users/login'
    end
  end
  
# registration page for players. All positions and all states for forms
get '/' do
  @positions = Position.all
  @states = State.all
  erb :player_reg

end

#creating a new player and storing what they selected
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
  #looping through and creating a new position for every position selected 
  player_position_id.each do |position_id|
  new_player_position = PlayerPosition.new
  new_player_position.player_id = new_player.id
  new_player_position.position_id = position_id
  new_player_position.save
  end
  redirect "/players/account"
end

#account home pages
get '/account' do
  user = User.find_by({:id => session[:user_id]})
  @player = Player.find_by({:user_id => session[:user_id]})
  @positions = @player.positions
  @messages = user.messages
  @sent_messages = Message.where("from_id = ?", session[:user_id])

  @following = user.relations
  #If these exit taht it outputs the count
  if @following.size > 0
  @following_count =  @following.count
  end
  if @messages.size > 0
  @inbox_count = @messages.count
  end
  if @sent_messages.size > 0
  @outbox_count = @sent_messages.count
  end

  erb :player_home
end

############### ALL ROUTES THAT DEAL WITH MESSAGING ##########################

#message inbox
get '/inbox' do
  user = User.find_by({:id => session[:user_id]})
  @messages = user.messages
  erb :player_inbox

end

#all sent messages
get '/outbox' do
  #getting all sent massages that are asigned to this users id.
  messages = Message.where("from_id = ?", session[:user_id])
  @sent_messages = []
  messages.each do |message|
    if message.deleted_by_user == false
      @sent_messages.push(message)
  end
end
  erb :player_outbox
end

#Route for an individual message, in the user inbox
get '/account/:id' do
  user = User.find_by({:id => session[:user_id]})
  @message = Message.find params[:id]
  message = Message.all

  @replies = @message.replies
  erb :player_message
end

# Post route that handles replies to a message
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
    message: "Your reply has been sent"
    }
    redirect "/players/account"
end

#deleting the message and message replies in the users inbox
delete '/account/:id' do
  user = User.find_by({:id => session[:user_id]})
  message = Message.find params[:id]
  replies = message.replies
  message_id = message.id
  message.deleted_by_user = true
puts "=================="
puts message.count_of_delete
puts "^^^^^^^^count of delete^^^^^^^^^^^^^^"
  if message.count_of_delete <= 1
    message.count_of_delete += 1
    message.save
  end
  if message.count_of_delete == 2
    replies.each  do |relation|
    relation.destroy
    end
    message.destroy
  end

session[:message] = {
    success: true,
    status: "Good",
    message: "Message #{message_id} has been deleted"
    }
  redirect '/players/account'
end

# Posting a message to that college
post '/college/:id/message' do
  logged_in_user = User.find_by ({ :username => session[:username] })
   
  college = College.find params[:id]
  new_message = Message.new
  new_message.content = params[:content]
  new_message.title = params[:title]
  new_message.from_id = logged_in_user.id
  new_message.user_id = college.user.id
  new_message.count_of_delete = 0
  new_message.deleted_by_user = false
  
  new_message.save

  session[:message] = {
    success: true,
    status: "Good",
    message: "Your message has been sent"
    }
    
    redirect "/players/account"
end
############### ALL ROUTES THAT DEAL WITH FOLLOWING A USER #######################


#all the users that are being followed
get '/following' do
  user = User.find_by({:id => session[:user_id]})
  @following = user.relations
  erb  :player_following
end

#unfollow a user
delete '/following/:id' do
  following = Relation.find params[:id]
  following.destroy

  session[:message] = {
    success: true,
    status: "Good",
    message: "User successfully unfollowed  #{following.name} "
    }
  redirect '/players/account'
end

# Following the college
post '/college/:id/follow' do
  
  logged_in_user = User.find_by({:username => session[:username]})
  college = College.find params[:id]
  new_relation = Relation.new
  new_relation.name = college.name
  new_relation.user_id = logged_in_user.id
  new_relation.other_user_if_college = college.id
  
  new_relation.save
  
  session[:message] = {
    success: true,
    status: "Good",
    message: "You are now following #{college.name}"
    }

    redirect "players/account"
    
end


####### ROUTES FOR FINDING THE MATCHES AND THEIR GET ROUTE ####################

# The matching colleges
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

#get route for an individual college
get '/college/:id' do
  @college = College.find params[:id]
  city_name = @college.city
  found_state = State.find_by({:id  => @college.state_code})
  
  state = found_state[:code]
  # for the google maps on the views
  @modified = address(city_name, state)
  @other_user = @college.name

  school = @college.school_name

  uri = URI("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{school}&inputtype=textquery&&fields=formatted_address,name,website,price_level&&key=AIzaSyAX--aXSI4BhWWyxHFBLCnhg5MdMlHf_qM")
  it = Net::HTTP.get(uri)
  parsed_it = JSON.parse it 
  @places = parsed_it["results"]
  
  @location =  @places.first['formatted_address']
    
  erb :college_show
end


######### ROUTES FOR UPDATING ACCOUNT #######################################


# edit page for the players account.
get '/:id/edit' do
  @positions = Position.all
  @player = Player.find params[:id]
  erb :player_edit
end

#put route for account edit.
put '/account/:id' do
  updated_player = Player.find params[:id]
  updated_player.name = params[:name]
  updated_player.school_name = params[:school_name]
  updated_player.state_code = params[:state_code]
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

######################### HELPER METHODS ###############################
#modifying address for google maps
def address(city_name, state)
  arr_city = city_name.split(' ')
  if arr_city.length > 1
    arr_city = arr_city.join('+')
    return arr_city + ',' + state
  elsif arr_city.length == 1  
    return  arr_city[0] + ',' + state
  end
end	