#!/usr/bin/env ruby

require "dotenv"
require "kappa"
require_relative "markdown_updater"

Dotenv.load(File.join(File.dirname(__FILE__), '.env'))

Twitch.configure do |config|
  config.client_id = ENV["TWITCH_ID"]
end

def fetchCurrentStreamers()
  current_streamers = Array.new
  all_streamers    = IO.readlines(File.join(File.dirname(__FILE__), "whitelist.txt")).map(&:chomp)

  Twitch.streams.find(:channel => all_streamers) do |stream|
    streamer = {}
    streamer[:name] = stream.channel.name
    streamer[:game] = stream.game_name

    current_streamers << streamer
  end

  updateStreamers(current_streamers, all_streamers)
  puts Time.now.to_s + ': Success'
end

fetchCurrentStreamers()
