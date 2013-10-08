require 'pry'
require 'twitter'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'dotenv'
require 'stock_quote'
set :server, 'webrick'

Dotenv.load
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

$twitter = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end

get '/:stock' do
  @symbol = params[:stock]
  @company = StockQuote::Stock.quote(@symbol).company
  @exchange = StockQuote::Stock.quote(@symbol).exchange
  @high = StockQuote::Stock.quote(@symbol).high
  @low = StockQuote::Stock.quote(@symbol).low
  @volume = StockQuote::Stock.quote(@symbol).volume
  @price = StockQuote::Stock.quote(@symbol).last
  
  @tweets = $twitter.search("$#{@symbol}", :count => 10, :result_type => "recent").collect do |tweet|
    if tweet.lang == 'en'
      "#{tweet.user.screen_name}: #{tweet.text}"
    end
  end
  erb :stock
end