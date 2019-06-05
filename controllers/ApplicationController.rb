class ApplicationController < Sinatra::Base
  

  # find out what bundler is and what we use it for
  require 'bundler'
  Bundler.require()

  # find out exactly what sessions are and what we use them for ("locker" in coat check)
  enable :sessions

  #client sends request
  #server sends response  

  # ActiveRecord is an ORM that lets us communicate with our psql database
  # it lets us create models with associations, meaning: models have relationships with other models
  ActiveRecord::Base.establish_connection(
    :adapter => 'postgresql',
    :database => 'the_recruiter'
  )
  
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

  get('/demo') { 
    "demo"
  }

  # app.get('/demo', (req, res) => {
  #   res.send('demo')
  # })


  get '*' do
    halt 404
  end

end
