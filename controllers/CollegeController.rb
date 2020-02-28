class CollegeController < ApplicationController

  before do
    if !session[:logged_in]
      session[:message] = {
        success: false,
        status: "neutral",
        message: "You must be logged in to do that."
      }
      redirect '/users'
    end
  end

  get '/' do
    # get positions from postions table
    @positions = Position.all
    @states = State.all
    erb :college_reg
  end
  
  # post route that creates a college based on user input 
  post '/account' do
    new_college = College.new
    new_college.name = params[:name]
    new_college.school_name = params[:school_name]
    new_college.state_code = params[:state]
    new_college.city = params[:city]
    new_college.user_id = session[:user_id]
    new_college.save

    # this is an array of id's
    college_position_ids = params[:position]
  
    # loop over college_postiion_ids
    college_position_ids.each do |position_id|
    new_college_need = CollegeNeed.new
    new_college_need.college_id = new_college.id
    new_college_need.position_id = position_id
    new_college_need.save
  end
    redirect '/colleges/account'
  end
  
  get '/account' do
    user = User.find_by({:id => session[:user_id]})
    @college = College.find_by({ :user_id => session[:user_id]})
    @positions = @college.positions
    @messages = user.messages
   
    erb :college_home
  end

  get '/account/:id' do
  user = User.find_by({:id => session[:user_id]})
  @message = Message.find params[:id]

  @replies = @message.replies

  erb :college_message
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

    redirect '/colleges/account'

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
      message: "Your reply has been sent"
      }
      redirect "/colleges/account"

  end

  get '/matching-players' do
    @college = College.find_by({ :user_id => session[:user_id]})
    #find the college positions
    @positions = @college.positions
    #looping over players position with flat map to get a single array instead of an array of arrays
    @available_players = @positions.flat_map do |position|
      position.players
   end
   #this make it so there are no duplicates
   @available_players = @available_players.uniq()
    erb :player_match
   end

   get '/player/:id' do
    @player= Player.find params[:id]
    erb :player_show
  end

  post '/player/:id/message' do
    logged_in_user = User.find_by ({ :username => session[:username] })
    player = Player.find params[:id]

    new_message = Message.new
    new_message.content = params[:content]
    new_message.title = params[:title]
    new_message.user_id = player.user.id
    new_message.from_id = logged_in_user.id
    new_message.save
  
    session[:message] = {
      success: true,
      status: "Good",
      message: "Your message has been sent"
      }
      redirect "/colleges/account"
  end
  
  get '/:id/edit' do
    @positions = Position.all
    @college = College.find params[:id]
    erb :college_edit
  end
  
  put '/account/:id' do
    @college = College.find params[:id]
    @college.name = params[:name]
    @college.school_name = params[:school_name]
    @college.state = params[:state]
    @college.city = params[:city]
    @college.save
    
    found_positions = @college.college_needs
      
    found_positions.each do |relation|
      relation.destroy
    end
    #grabbing positions Id's to loop over
    college_position_ids = params[:position]
    # loop over college_postiion_ids
    college_position_ids.each do |position_id|
      new_college_need = CollegeNeed.new
      new_college_need.college_id = @college.id
      new_college_need.position_id = position_id
      new_college_need.save
    end
  redirect "/colleges/account"
  end
end