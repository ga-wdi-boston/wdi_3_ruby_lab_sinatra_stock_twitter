require 'twitter'
require 'dotenv'
require 'stock_quote'
require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'pry-debugger'
set :server, 'webrick'
Dotenv.load

# Stock symbol gem code...

# def stock_symbol(symbol)
# 	stock = StockQuote::Stock.quote(symbol) 
# 	puts "Company name: #{stock.company}"
# 	puts "Current time: #{stock.current_time_utc}"
# 	puts "Current value: #{stock.last}"
# 	puts "High: #{stock.high}"
# 	puts "Low: #{stock.low}"
# end


# stock_symbol("goog")

# Twitter gem code...
# Use the twitter rest client and search.

def twitter(symbol)
	client = Twitter::REST::Client.new do |config|
		config.consumer_key        		= ENV["CONSUMER_KEY"]
		config.consumer_secret    	= ENV["CONSUMER_SECRET"]
		config.access_token        	= ENV["ACCESS_TOKEN"]
		config.access_token_secret 	= ENV["ACCESS_SECRET"]
	end
	client.search("$#{symbol}").take(15).collect {|tweet| "#{tweet.user.screen_name}: #{tweet.text}"}
end

get '/stocks/:stock' do 
	stock_symbol = params[:stock]
	@stock = StockQuote::Stock.quote(stock_symbol)
	@tweets = twitter(params[:stock].to_s)
	
	erb :stocks
end

# get '/stocks/:symbol' do
# 	@symbol = params[:symbol]
# 	stock = StockQuote::Stock.quote(@symbol) 
# 	puts "Company name: #{stock.company}"
# 	puts "Current time: #{stock.current_time_utc}"
# 	puts "Current value: #{stock.last}"
# 	puts "High: #{stock.high}"
# 	puts "Low: #{stock.low}"
# 	@tweets = client.search("$#{@symbol}", :count => 10, :result_type => "recent")
# 	erb :stocks
# end	

# Show the stocks form. 
# get '/stocks/new' do 
# 	erb :stock_form #goest to stock_form page
# end

# post '/stocks/create' do 
# 	stock_name = params[:stock_name]
# 	@stock = StockQuote::Stock.quote(stock_name)
# 	@tweets = twitter(params[:stock_name].to_s)
# end


