class CollegeController < ApplicationController


get '/' do
  # get positions from postions table
  @positions = Position.all
  erb :college_reg
end

# post route that list creates a college based on user input 
post '/account' do

  new_college = College.new
  new_college.name = params[:name]
  new_college.school_name = params[:school_name]
  new_college.location = params[:location]
  new_college.email = params[:email]
  new_college.user_id =  session[:user_id]

  # assign the college a user id here (based on the session)
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
 
  # positions = CollegeNeed.find_by({ :college_id => @college.id })
  @positions = @college.positions
  puts "positions:"
  pp @positions
  erb :college_show
 
end

get '/matching-players' do
  @college = College.find_by({ :user_id => session[:user_id]})
  #find the college positions
  @positions = @college.positions

  puts "college positions:"
  pp @positions

  #looping over players position with flat map to get a single array instead of  #an array of arrays
  @available_players = @positions.flat_map do |position|
    
    puts "this specific position:"
    pp position
    
    position.players
 end
 #this make it so there are no duplicates
 @available_players = @available_players.uniq()
  erb :player_match
 end
 
end