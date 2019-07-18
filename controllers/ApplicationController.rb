class ApplicationController < Sinatra::Base
  
  require 'bundler'
  Bundler.require()
  require './config/environments'



  use Rack::Session::Cookie,  :key => 'rack.session',
                              :path => '/',
                              :secret => "lasdjfalksdjflaksdfalsdfjl"


 
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
