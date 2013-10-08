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


get '/stocks/:symbol' do
  topic = params[:symbol]
  topic_tweets = []
  stock = StockQuote::Stock.quote(topic)
  
  client.search(topic, count: 25, result_type: 'recent', lang: 'en').collect do |tweet|
    # topic_tweets << {user: tweet.attrs[:user][:screen_name], tweet: tweet.text}
    "#{tweet.text}"
  end
end