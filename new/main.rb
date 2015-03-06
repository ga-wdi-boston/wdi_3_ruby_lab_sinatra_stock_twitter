require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'twitter'
require 'dotenv'
require 'stock_quote'
set :server, 'webrick'


OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Dotenv.load

$twitter = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret    = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end

get '/stocks/new' do
	erb :stock_form
end

post '/stocks/create' do
	@symbol = params[:stock_name]
	@stock= StockQuote::Stock.quote(@symbol)
	@company = @stock.company
	@high = @stock.high
	@low = @stock.low
	@price = @stock.last
	@volume = @stock.volume
	@tweets = $twitter.search("$#{@symbol}", :count => 25, :result_type => "recent").collect do |tweet|
  		if tweet.lang == 'en'
  			"#{tweet.user.screen_name}: #{tweet.text}"
  		end
	end

	erb :stock
end
