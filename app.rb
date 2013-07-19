require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/model'
require_relative './brewinfo'

enable :sessions

before do
	@session = session
end

get '/' do
	erb :index
end 

get '/about' do
	erb :about
end

get '/contact' do
	erb :contact
end

post '/search' do
	term = params[:term]
	@term = term
	brew = BrewInfo.new
	@brew_info = brew.get_brew_info( URI.escape( term ) )
	@session['brews'] = @brew_info
	erb :results
end

get '/random' do
	#search for a random brew
	brew = BrewInfo.new
	@brew_info = brew.get_brew_info("yazoo")
	@session['brews'] = @brew_info
	erb :results
end

get '/brew/:type/:id' do
	@type = params[:type]
	id = params[:id]
	brew = BrewInfo.new
	
	if ( @type.to_s == "beer" )
		@beer = brew.get_beer_info( id )
		erb :brew
	else
		@brewery = brew.get_brewery_info( id )
		erb :brewery
	end
end

# Not currently used
post '/submit' do
	@model = Model.new(params[:model])
	if @model.save
		redirect '/models'
	else
		"Sorry, there was an error!"
	end 
end

# Not currently used
get '/models' do
	@models = Model.all
	erb :models
end
	