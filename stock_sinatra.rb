require 'pry'
require 'dotenv'
require 'stock_quote'
require 'twitter'
require 'sinatra'
require 'sinatra/reloader' if development?

set :server, 'webrick'
Dotenv.load

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

# def tweet_stocks(symbol)
#   client.search(symbol)
# end

get '/stocks/new' do
  erb :stock_form
end

post '/stocks/create' do
  stock_name = params[:stock_name]
  @stock = StockQuote::Stock.quote(stock_name)
  erb :show_stock
end

get '/stocks/:symbol' do
  @symbol = params[:symbol]
  # stock = StockQuote::Stock.quote(@symbol)
  
  @stock_tweets = client.search(@symbol, count: 25, result_type: 'recent', lang: 'en').collect do |tweet|
    "#{tweet.text}"
  end
  erb :twitstock
end