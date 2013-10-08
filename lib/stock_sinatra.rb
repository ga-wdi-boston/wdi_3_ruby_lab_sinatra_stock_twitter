#require 'pry'
require 'dotenv'
require 'stock_quote'
require 'twitter'
require 'sinatra'
require 'sinatra/reloader'
set :server, 'webrick'
Dotenv.load

streaming_client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

topic = 'obama'
obama_tweets = []
i = 0

streaming_client.filter(track: topic) do |tweet|
  if tweet.lang == 'en'
    i += 1
    obama_tweets << {user: tweet.attrs[:user][:screen_name], tweet: tweet.text}
    puts "#{i} tweets gathered"
    puts "#{tweet.attrs[:user][:screen_name]} tweeted about Obama: #{tweet.text}"
  end
  break if i > 10
end