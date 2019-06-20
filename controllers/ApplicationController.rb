class ApplicationController < Sinatra::Base
  
# find out what bundler is and what we use it for
  require 'bundler'
  Bundler.require()
  require './config/environments'

  # find out exactly what sessions are and what we use them for ("locker" in coat check)
  enable :sessions

  use Rack::Session::Cookie,  :key => 'rack.session',
                              :path => '/',
                              :secret => "as;dlfkja;sdlfkja;sldkfja;lskdjfa;lsdkjf"


  # Set up CORS
  register Sinatra::CrossOrigin

  configure do
    enable :cross_origin
  end

  set :allow_origin, :any
  set :allow_methods, [:get, :post, :put, :options, :patch, :delete, :head]
  set :allow_credentials, true

  options '*' do
    response.headers["Allow"] = "HEAD,GET,PUT,PATCH,POST,DELETE,OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "X-Requested-Wtih, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
    200
  end
  
  
  #client sends request
  #server sends response  

  # ActiveRecord is an ORM that lets us communicate with our psql database
  # it lets us create models with associations, meaning: models have relationships with other models

  
  # we write routes that handle requests, but we use 
  # middleware to intercept any clent request before it gets to the the correct route
  use Rack::MethodOverride
  set :method_override, true
  
  set :views, File.expand_path('../../views', __FILE__)

  # teach it how to find static assets
  set :public_dir, File.expand_path('../../public', __FILE__)

  get '/' do 
    erb :home
  end
 
  get '/test' do
    some_text = "TEST 123"
    binding.pry 
    "pry has finished -- here's some_text #{some_text}"

  end

 


  get '*' do
    halt 404
  end

end
