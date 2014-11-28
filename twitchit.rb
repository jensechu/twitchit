require "kappa"
require "json"
require "dotenv"
require_relative "css_updater"

Twitch.configure do |config|
  config.client_id = ENV["TWITCH_ID"]
end

def fetchActiveStreamers()
  streamers = Array.new
  users     = IO.readlines("whitelist.txt").map(&:chomp)
  
  Twitch.streams.find(:channel => users) do |stream|
    streamers << stream.channel.name
  end

  updateStreamers(streamers)
end

fetchActiveStreamers()
