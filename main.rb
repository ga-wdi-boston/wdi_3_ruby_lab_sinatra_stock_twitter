require 'twitter'
require 'pry'
require 'dotenv'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'stock_quote'


set :server, 'webrick'

Dotenv.load

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]

end

get '/stocks/new' do
	erb :stock_form 
end

post '/stocks/create' do
	@stock_symbol= params[:stock]
	@stock = StockQuote::Stock.quote(@stock_symbol)
	@company = StockQuote::Stock.quote(@stock_symbol).company
	@last = StockQuote::Stock.quote(@stock_symbol).last
	@open = StockQuote::Stock.quote(@stock_symbol).open
	@volume  = StockQuote::Stock.quote(@stock_symbol).volume 
	@tweets = client.search(@stock_symbol, :count => 25, :result_type => "recent", :lang => "en").collect do |tweet|
	  "#{tweet.text}"
	end
	erb :stocks
end 


#binding.pry 


