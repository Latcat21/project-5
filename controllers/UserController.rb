class UserController < ApplicationController

 
  get '/login' do
    erb :login
  end

  #  the login 
  post '/login' do
    # find user by username
    user = User.find_by username: params[:username]
    pw = params[:password]
    
    if user && user.authenticate(pw) 
      session[:logged_in] = true
      session[:username] = user.username
      session[:user_id] = user.id
      
      if user.player_user == true
        session[:user_type] == 'player'
        redirect '/players/account'
      else
        session[:user_type] == 'college'
       redirect '/colleges/account'
      end
# else 
    else
      # error -- incorrect un or pw
    session[:message] = {
        success: false,
        status: "bad",
        message: "Invalid username or password."
      }
    redirect '/users/login'
    end
end
  
  # shows register 
  get '/register' do
    erb :register
  end

  # do registration
  post '/register' do
    # check if user exists 
    user = User.find_by username: params[:username]
      
    if !user
      # create user 
      user = User.new
      user.username = params[:username]
      user.password = params[:password]
      user_type = params[:account_type]

      if user_type == 'player'
        user.player_user = true
        session[:user_type] = 'player'
        
      else 
        user_type == 'college'
        user.college_user == true
        session[:user_type] = 'college'
      end # setting user type based on input

      user.save


      session[:logged_in] = true
      session[:username] = user.username
      session[:user_id] = user.id
     

    if user.player_user == true
        session[:user_type] == "player"
        redirect '/players'
    else user.college_user == true
      session[:user_type] == "college"
         redirect '/colleges'
  
    end

    else 
      # session message -- username taken
    session[:message] = {
        success: false,
        status: "bad",
        message: "Sorry, username #{params[:username]} is already taken."
      }
       # redirect to register so they can try again
      redirect '/users/register'
      end # if user does or does not exist 
    end # post

    # logout
  get '/logout' do
    username = session[:username] 
    session.destroy
    
   @message =  session[:message] = {
      success: true,
      status: "neutral",
      message: "User #{username} logged out."
    }
    redirect '/users/login'
  end
end

