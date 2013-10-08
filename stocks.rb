require 'twitter'
require 'pry'
require 'dotenv'
require 'stock_quote'
require 'sinatra'
require 'sinatra/reloader'
set :server, 'webrick'

Dotenv.load

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end


get '/stocks/:stock' do

	stock = params[:stock]

	@recent_tweets = client.search("$#{stock}", :count => 50, :result_type => "recent").collect do |tweet|
	  "#{tweet.user.screen_name}: #{tweet.text}"
	end
	@stock_current = "$#{StockQuote::Stock.quote("#{stock}").last}"
	@stock_name = StockQuote::Stock.quote("#{stock}").company
	@exchange = StockQuote::Stock.quote("#{stock}").exchange
	@volume = StockQuote::Stock.quote("#{stock}").volume
	@avg_volume = StockQuote::Stock.quote("#{stock}").avg_volume
	
	if @volume > @avg_volume
		@trend = 'higher'
	elsif @volume < @avg_volume
		@trend = 'lower'
	else
		@trend = 'normal'
	end

	@times = (@volume / @avg_volume).to_i

	@title = "#{@stock} Buzz"
	@heading = "The buzz about #{@stock_name}:"
	erb :stocks
end