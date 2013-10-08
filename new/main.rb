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
  config.consumer_secret    = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]

end

stock = "GOOG"



user_input = gets.chomp

@stockquote = StockQuote::Stock.quote(stock)
@tweets = client.search(stock, :count => 25, :result_type => "recent", :lang => "en").collect"#{tweet.text}"

binding.pry

topics = gets.chomp
get 'stocks/:stock' do

end



