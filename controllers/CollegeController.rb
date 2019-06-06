class CollegeController < ApplicationController


get '/' do
  # get positions from postions table
  @positions = Position.all
  erb :college_reg
end

# post route that list creates a college based on user input 
post '/' do

  puts "here are the params"
  pp params

  new_college = College.new
  new_college.name = params[:name]
  new_college.school_name = params[:school_name]
  new_college.location = params[:location]

  new_college.save

  puts "new_college: "
  pp new_college 


  # this is an array of id's
  college_position_ids = params[:position]


  # loop over college_postiion_ids
  college_position_ids.each do |position_id|

    new_college_need = CollegeNeed.new

    new_college_need.college_id = new_college.id

    new_college_need.position_id = position_id
    
    new_college_need.save

  end

  "check terminal"

end






# get '/college-account' do


#   erb :player_results

# end

end