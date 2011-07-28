require 'rubygems'
require 'sinatra'
require 'mongoid'
require 'albino'

require ::File.expand_path('../models/paste',  __FILE__)

class App < Sinatra::Application
  configure do
    Mongoid.load!("config/mongoid.yml")
  end
  
  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
    
    def colorize(text, lang)
      Albino.colorize(text, lang.to_sym)
    end
  end
  
  get '/' do
    @pastes = Paste.all(sort: [[ :date, :desc ]])
    erb :index
  end
  
  get '/pastes/new' do
    @paste = Paste.new
    erb :"pastes/new"
  end
  
  post '/pastes/create' do
    @paste = Paste.new(params[:paste])
    @paste.date = Time.now
    @paste.save
    
    redirect '/'
  end
end
