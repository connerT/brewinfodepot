require 'rubygems'
require 'sinatra'
# require 'sinatra/activerecord'
# require './config/environments' #database configuration
# require './models/model'
require_relative './brewinfo'
require_relative './apis/flickr/flickr'

enable :sessions

class InfoHolder
  attr_accessor :brewdb, :flickr
end

before do
	@session = session
end

get '/' do
	flickr_info = FlickrInfo.new
	@flickr = flickr_info.get_flickr_photos( "craft beer" )
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
  @info = InfoHolder.new
	type = params[:type]
	id = params[:id]
	brew_info = BrewInfo.new
	flickr_info = FlickrInfo.new
	
	if ( type.to_s == "beer" )
		beer = brew_info.get_beer_info( id )
		flickr = flickr_info.get_flickr_photos( beer.name )
		@info.brewdb = beer
		@info.flickr = flickr
		erb :brew
	else
		brewery = brew_info.get_brewery_info( id )
		flickr = flickr_info.get_flickr_photos( brewery.name )
		@info.brewdb = brewery
		@info.flickr = flickr
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
	