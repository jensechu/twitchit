require "redd"
require "dotenv"

Dotenv.load(File.join(File.dirname(__FILE__), '.env'))

SUBREDDIT = ENV["SUBREDDIT"]

template        = File.join(File.dirname(__FILE__), "template.css")
@active_template = File.join(File.dirname(__FILE__), "current.css")

@new_css    = open(template, &:read)
@active_css = open(@active_template, &:read)

@redd = Redd::Client::Authenticated.new_from_credentials(ENV["USERNAME"], ENV["PASSWORD"])

def updateStreamers(streamers)
  streamers.each { |user|
    user.sub! "_", "-" #Reddit image paths cannot contain underscores
    @new_css.sub! "url(%%#{user}-twitch-offline%%)", "url(%%#{user}-twitch-online%%)"
  }

  if @active_css == @new_css
    puts 'Active stylesheet is current.'
    exit
  end

  File.open(@active_template, 'w') { |file| file.write(@new_css) }
  result = @redd.edit_stylesheet(SUBREDDIT, @new_css)
end
