require "dotenv"
require "kappa"
require_relative "css_updater"

Dotenv.load(File.join(File.dirname(__FILE__), '.env'))

Twitch.configure do |config|
  config.client_id = ENV["TWITCH_ID"]
end

def fetchActiveStreamers()
  streamers = Array.new
  users     = IO.readlines(File.join(File.dirname(__FILE__), "whitelist.txt")).map(&:chomp)

  Twitch.streams.find(:channel => users) do |stream|
    streamers << stream.channel.name
  end

  updateStreamers(streamers)
  puts Time.now.to_s + ': Success'
end

fetchActiveStreamers()
