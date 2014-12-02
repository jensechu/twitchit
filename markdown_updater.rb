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
@attrs[:description]        = ''

def updateStreamers(current_streamers, all_streamers)
  current_streamers.each { |user|
    online_text  = "
      [#{user[:name]}](http://www.twitch.tv/#{user[:name]} 'twitch-online') \n
      *→ playing #{user[:game]}*"

    @new_markdown.sub! "twitchit(#{user[:name]})", online_text
  }

  all_streamers.each { |user|
    offline_text = "[#{user}](http://www.twitch.tv/#{user} 'twitch-offline')"
    @new_markdown.sub! "twitchit(#{user})", offline_text
  }

  # Convert to proper markdown because Reddit API doesn't return these as markdown
  @new_markdown.gsub! '&gt;', '>'
  @new_markdown.gsub! '&lt;', '<'

  # If current markdown is already accurate then exit
  if @current_markdown == @new_markdown
    puts Time.now.to_s + ' Current markdown is up-to-date.'
    exit
  end

  # Update local current to avoid hitting Reddit API to check if markdown needs updating
  File.open(@current_template, 'w') { |file| file.write(@new_markdown) }
  result = @redd.edit_stylesheet(ENV["SUBREDDIT"], @new_markdown)

  # Update the live markdown
  @attrs[:description] = @new_markdown
  @redd.site_admin(@attrs)
end
