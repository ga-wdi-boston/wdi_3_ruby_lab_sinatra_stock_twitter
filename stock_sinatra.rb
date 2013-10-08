#require 'pry'
require 'dotenv'
require 'stock_quote'
require 'twitter'
require 'sinatra'
require 'sinatra/reloader'
set :server, 'webrick'
Dotenv.load

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["CONSUMER_KEY"]
  config.consumer_secret     = ENV["CONSUMER_SECRET"]
  config.access_token        = ENV["ACCESS_TOKEN"]
  config.access_token_secret = ENV["ACCESS_SECRET"]
end

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

topic = 'GOOG'
topic_tweets = []
i = 0

# streaming_client.filter(track: topic) do |tweet|
#   if tweet.lang == 'en'
#     i += 1
#     goog_tweets << {user: tweet.attrs[:user][:screen_name], tweet: tweet.text}
#     puts "#{i} tweets gathered"
#     puts "#{tweet.attrs[:user][:screen_name]} tweeted about GOOG: #{tweet.text}"
#   end
#   break if i > 25
# end

client.search(topic, count: 25, result_type: 'recent', lang: 'en').each do |tweet|
  topic_tweets << {user: tweet.attrs[:user][:screen_name], tweet: tweet.text}
  puts "#{tweet.attrs[:user][:screen_name]} tweeted about #{topic}: #{tweet.text}\n"
end