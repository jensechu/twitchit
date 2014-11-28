require "redd"
require "dotenv"
require "awesome_print"

Dotenv.load

SUBREDDIT = "girlgamerscss"
template  = File.join(File.dirname(__FILE__), "template.css")

@css_contents = open(template, &:read)
@redd         = Redd::Client::Authenticated.new_from_credentials(ENV["USERNAME"], ENV["PASSWORD"])

def updateStreamers(streamers)
  streamers.each { |user|
    user.sub! "_", "-" #Reddit image paths cannot contain underscores
    @css_contents.sub! "url(%%#{user}-twitch-offline%%)", "url(%%#{user}-twitch-online%%)"
  }

  result = @redd.edit_stylesheet(SUBREDDIT, @css_contents)
  ap result
end
