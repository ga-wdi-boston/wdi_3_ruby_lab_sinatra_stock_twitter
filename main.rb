require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry'
require 'twitter'
require 'multi_json'
require 'stock_quote'
require 'dotenv'

set :server, 'webrick'

Dotenv.load

client = Twitter::REST::Client.new do |config|
	config.consumer_key = 				ENV["CONSUMER_KEY"]
	config.consumer_secret = 			ENV["CONSUMER_SECRET"]
	config.access_token = 				ENV["ACCESS_TOKEN"]
	config.access_token_secret = 	ENV["ACCESS_SECRET"]
end

# show the stock form
get '/stock/new' do
	erb :stock_form
end

post '/stock/create' do
	stock_name = params[:stock_name]
	@stock = StockQuote::Stock.quote(stock_name)
	# @stock_current = "$#{StockQuote::Stock.quote("#{stock_name}").last}"
	erb :show_stock
end

get '/stock/:symbol' do
@symbol = params[:symbol]

stock = StockQuote::Stock.quote(@symbol)


	@company = stock.company
	@stock_last = stock.last
	@daily_open = stock.open
	@daily_close = stock.y_close
	@high = stock.high


 @recent_tweets = client.search(@symbol, :count => 25, :result_type => "recent", :lang => "en").collect do |tweet|
  "#{tweet.text}"

end

	  return erb :stocks

end
