class CollegeController < ApplicationController

  before do
    puts "before filter is running"

    if !session[:logged_in]
      # message
      session[:message] = {
        success: false,
        status: "neutral",
        message: "You must be logged in to do that."
      }
      #redirect
      redirect '/users'
    end
  end

  get '/' do
    # get positions from postions table
    @positions = Position.all
    erb :college_reg
  end
  
  # post route that creates a college based on user input 
  post '/account' do
    new_college = College.new
    new_college.name = params[:name]
    new_college.school_name = params[:school_name]
    new_college.state = params[:state]
    new_college.city = params[:city]
    new_college.email = params[:email]
    new_college.user_id =  session[:user_id]
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
    @college = College.find_by({ :user_id => session[:user_id]})
    @positions = @college.positions
    erb :college_home
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
    @college.email = params[:email]
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