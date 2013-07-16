require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/model'
require_relative './brewinfo'

get '/' do
	erb :index
end 

post '/submit' do
	@model = Model.new(params[:model])
	if @model.save
		redirect '/models'
	else
		"Sorry, there was an error!"
	end 
end

get '/models' do
	@models = Model.all
	erb :models
end

get '/about' do
	erb :about
end

get '/contact' do
	erb :contact
end

get '/random' do
	#search for a random brew
	brew = BrewInfo.new
	@brew_info = brew.get_brew_info("yazoo")
	puts @brew_info
	erb :brew
end
	