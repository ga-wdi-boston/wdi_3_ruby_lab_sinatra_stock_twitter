
require 'twitter'
require 'pry'
require 'dotenv'
require 'stock_quote'
require 'sinatra'
require 'sinatra/reloader' if development? 
Dotenv.load
set :server, 'webrick'



def twitter(company)
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = ENV["ACCESS_TOKEN"]
    config.access_token_secret = ENV["ACCESS_SECRET"]
  end
  client.search("$#{company}".take(15).collect {|tweet|
    "#{tweet.user.screen_name}: #{tweet.text}" }
  end

get '/info/:stock' do  
  @stock = StockQuote::Stock.quote(params[:stock].to_s)
  @tweets = twitter(params[:stock].to_s) 
  erb :twitter_and_stock 
end



