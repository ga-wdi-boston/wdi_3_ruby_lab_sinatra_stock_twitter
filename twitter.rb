require 'twitter'
require 'dotenv'
require 'pry'

set :server, 'webrick'

client = Twitter::Streaming::Client.new do |config|
config.consumer_key        		= ENV["CONSUMER_KEY"]
  config.consumer_secret    	= ENV["CONSUMER_SECRET"]
  config.access_token        	= ENV["ACCESS_TOKEN"]
  config.access_token_secret 	= ENV["ACCESS_SECRET"]
end

topic = "obama"
obama_tweets = []
i = 0
binding.pry
client.filter(track: topic) do |tweet|
	if tweet.lang == "en"
		i += 1
		obama_tweets << {username: tweet.attrs[:user][:screen_name], tweet: tweet.text}
		puts "#{i} tweets gathered"
	end
	break if i >= 25
end

obama_tweets.each do |tweet_data|
    puts "Username: #{tweet_data[:username]}, Tweet: #{tweet_data[:tweet]}"
end

