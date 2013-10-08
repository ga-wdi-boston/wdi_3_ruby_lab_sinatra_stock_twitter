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

#shows the stock form
get '/stocks/new' do
  erb :stock_form
end

post '/stocks/create' do
  @symbol = params[:stock_name]
  @stock = StockQuote::Stock.quote(@symbol)
  @company = @stock.company
  @exchange = @stock.exchange
  @high = @stock.high
  @low = @stock.low
  @volume = @stock.volume
  @price = @stock.last
  
  @tweets = $twitter.search("$#{@symbol}", :count => 10, :result_type => "recent").collect do |tweet|
    if tweet.lang == 'en'
      "#{tweet.user.screen_name}: #{tweet.text}"
    end
  end
  erb :stock
end