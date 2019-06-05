class CollegeController < ApplicationController


get '/' do
  # get positions from postions table

  erb :college_index
end

# post route that list creates a college based on user input 
post '/' do

  puts params[:position]

  new_college = College.new
  new_college.name = params[:name]
  new_college.school_name = params[:school_name]
  new_college.location = params[:location]

  new_college.save

  

  college_position_ids = params[:position]


  # loop over college_postiion_ids
    # insert row into table with the position Id and the college id
    #then save it using acctive recoded. uisng 
  


    # i = 0
    # while i < college_positions.length do
    # end

    # console.log(college_positions)
  #   create entry in thru table with that position's id
  #   save entry in thru table

  "check terminal"

  # redirect '/player-search'

end

get '/player-results' do
  erb :player_results

end

end