require 'pry'
require 'twitter'
require 'dotenv'
require 'stock_quote'
require 'sinatra'
require 'sinatra/reloader' if development?
Dotenv.load
set :server, 'webrick'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def twitter(company)
	client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret    = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end
	client.search(company).take(15).collect { |tweet| "#{tweet.user.screen_name}: #{tweet.text}"}
end



get '/stock/:stock' do
	
	stock_sym = params[:stock].to_s
	@stock = StockQuote::Stock.quote(stock_sym)
	@tweets = twitter(@stock.company)
	erb :twitter_stock

end

