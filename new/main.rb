require 'twitter'
require 'pry'
require 'dotenv'
require 'sinatra'
require 'sinatra/reloader' if development?
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

# stock = "GOOG"



get '/:stock' do
	@symbol = params[:stock]
	@company = StockQuote::Stock.quote(@symbol).company
	@high = StockQuote::Stock.quote(@symbol).high
	@low = StockQuote::Stock.quote(@symbol).low
	@price = StockQuote::Stock.quote(@symbol).last
	@volume = StockQuote::Stock.quote(@symbol).volume
	@tweets = $twitter.search("$#{@symbol}", :count => 25, :result_type => "recent").collect do |tweet|
  		if tweet.lang == 'en'
  			"#{tweet.user.screen_name}: #{tweet.text}"
  		end
	end

	erb :stock
end


