require 'twitter'
require 'pry'
require 'dotenv'
require 'stock_quote'
require 'sinatra'
require 'sinatra/reloader'

# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Dotenv.load

# client = Twitter::Streaming::Client.new do |config|
#   config.consumer_key        = ENV["CONSUMER_KEY"]
#   config.consumer_secret     = ENV["CONSUMER_SECRET"]
#   config.access_token        = ENV["ACCESS_TOKEN"]
#   config.access_token_secret = ENV["ACCESS_SECRET"]
# end


# def stream(client, topic)
# 	  client = Twitter::Streaming::Client.new do |config|
# 	  config.consumer_key        = ENV["CONSUMER_KEY"]
# 	  config.consumer_secret     = ENV["CONSUMER_SECRET"]
# 	  config.access_token        = ENV["ACCESS_TOKEN"]
# 	  config.access_token_secret = ENV["ACCESS_SECRET"]
# 	end
# 	topics = [topic]
# 	client.filter(:track => topics.join(",")) do |tweet| 
# 		if tweet.lang == 'en'
# 			puts tweet.text
# 		end
# 	end
# end

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end