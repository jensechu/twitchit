require "redd"
require "dotenv"

Dotenv.load(File.join(File.dirname(__FILE__), '.env'))
SUBREDDIT = 'girlgamerscss'

r = Redd::Client::Authenticated.new_from_credentials(
ENV['USERNAME'],
ENV['PASSWORD']
)

settings = r.about_edit(SUBREDDIT)
attrs    = settings.attributes.clone

attrs[:allow_top] = false
attrs[:css_on_cname] = true
attrs[:lang] = attrs[:language]
attrs[:link_type] = attrs[:content_options]
attrs[:name] = 'girlgamerscss'
attrs[:show_cname_sidebar] = true
attrs[:sr] = attrs[:subreddit_id]
attrs[:submit_link_label] = ''
attrs[:submit_text_label] = ''
attrs[:type] = attrs[:subreddit_type]
attrs[:description] = attrs[:description]

attrs[:description].gsub! '&gt;', '>'
attrs[:description].gsub! '&lt;', '<'

puts attrs[:description]

r.site_admin(attrs)
