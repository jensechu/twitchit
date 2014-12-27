twitchit
========

Twitchit is a Twitch streamer status indicator for subreddits. Twitchit polls the Twitch API for users in your whitelist and updates your subreddit's markdown (sidebar) when a whitelisted user's status has changed. 


## Example

## Usage

* `git clone https://github.com/jensechu/twitchit.git`
* `cd twitchit`
* `touch .env`
* Edit `.env`
```
USERNAME="REDDIT_USERNAME"
PASSWORD="REDDIT_PASSWORD"
TWITCH_ID="TWITCH_API_KEY"
SUBREDDIT="SUBREDDIT"
```
* `bundle install`
* Edit `whitelist.txt` to have a list of valid twitch users
* Edit `template.md` to have the master copy of your subreddit markdown
* Edit `template.md` with `twitchit(TWITCH_USER)` where you want the online/offline indicators to be for each user
* Run `ruby twitchit.rb`

## Online Twitch Stream

#### Markdown
```
* [TWITCH_USER](http://www.twitch.tv/TWITCH_USER 'twitch-online') 
  *playing Grand Theft Auto V*

```

#### Custom CSS
```
a[title="twitch-online"] {
 CUSTOM ONLINE STYLES
}
```

## Offline Twitch Stream

#### Markdown
```
* [TWITCH_USER](http://www.twitch.tv/TWITCH_USER 'twitch-offline')
```

#### Custom CSS
```
a[title="twitch-offline"] {
 CUSTOM OFFLINE STYLES
}
```


