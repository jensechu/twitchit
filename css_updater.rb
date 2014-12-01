require "redd"
require "dotenv"

Dotenv.load(File.join(File.dirname(__FILE__), '.env'))

template          = File.join(File.dirname(__FILE__), "template.md")
@current_template = File.join(File.dirname(__FILE__), "current.md")

@new_markdown     = open(template, &:read)
@current_markdown = open(@current_template, &:read)

@redd = Redd::Client::Authenticated.new_from_credentials(ENV["USERNAME"], ENV["PASSWORD"])

settings = @redd.about_edit(ENV["SUBREDDIT"])
@attrs    = settings.attributes.clone

# SUBREDDIT SETTINGS
# API requires all of these fields
@attrs[:allow_top]          = false
@attrs[:css_on_cname]       = true
@attrs[:lang]               = @attrs[:language]
@attrs[:link_type]          = @attrs[:content_options]
@attrs[:name]               = ENV["SUBREDDIT"]
@attrs[:show_cname_sidebar] = true
@attrs[:sr]                 = @attrs[:subreddit_id]
@attrs[:submit_link_label]  = ''
@attrs[:submit_text_label]  = ''
@attrs[:type]               = @attrs[:subreddit_type]
@attrs[:description]        = @attrs[:description]

def updateStreamers(current_streamers, all_streamers)
  all_streamers.each { |user|
    offline_text = "[#{user}](http://www.twitch.tv/#{user})"

    unless current_streamers.include? user
      @new_markdown.sub! "twitchit(#{user})", offline_text
    end
  }

  current_streamers.each { |user|
    online_text  = "[#{user} IS ONLINE](http://www.twitch.tv/#{user})"

    @new_markdown.sub! "twitchit(#{user})", online_text
  }

  # Convert to proper markdown because Reddit API doesn't return these as markdown
  @attrs[:description].gsub! '&gt;', '>'
  @attrs[:description].gsub! '&lt;', '<'

  # If current markdown is already accurate then exit
  if @current_markdown == @new_markdown
    puts Time.now.to_s + ' Current markdown is up-to-date.'
    exit
  end

  # Update local current to avoid hitting Reddit API to check if markdown needs updating
  File.open(@current_template, 'w') { |file| file.write(@new_markdown) }
  result = @redd.edit_stylesheet(ENV["SUBREDDIT"], @new_markdown)

  # Update the live markdown
  @redd.site_admin(@attrs)
end
