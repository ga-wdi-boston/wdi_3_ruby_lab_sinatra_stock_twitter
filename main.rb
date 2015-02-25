require 'sinatra'
require 'sinatra/reloader' if development?
require 'twitter'
require 'dotenv'
require 'pry'
require 'stock_quote'
Dotenv.load
set :server, 'webrick'

# puts "#{stock.company} (#{stock.symbol}) is trading at #{stock.last} on #{stock.exchange}. #{stock.symbol} has a high of #{stock.high} and a low of #{stock.low}. #{stock.company}'s market cap is #{stock.market_cap}."

def twitter(company)
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = ENV["ACCESS_TOKEN"]
    config.access_token_secret = ENV["ACCESS_SECRET"]
  end
  client.search(company).take(15).collect { |tweet|
  "#{tweet.user.screen_name}: #{tweet.text}" }
end

get '/stocks/:stock' do
  @stock = StockQuote::Stock.quote(params[:stock].to_s)
  @tweets = twitter(@stock.company)
  erb :stock
end