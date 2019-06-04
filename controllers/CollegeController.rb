class CollegeController < ApplicationController


get '/' do
  
  erb :college_index
end

# post route that list creates a college based on user input 
post '/' do

  puts params

  # new_college = College.new
  # new_college.name = params[:name]
  # new_college.school_name = params[:school_name]
  # new_college.location = params[:location]
  # new_college.save


  # iterate over params[:position]
  #   find that position in positions table
  #   create entry in thru table with that position's id
  #   save entry in thru table

  "check terminal"

  # redirect '/player-search'

end

get '/player-results' do
  erb :player_results

end

end