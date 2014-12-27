twitchit
========

Twitchit is a Twitch streamer status indicator for subreddits. Twitchit polls the Twitch API for users in your whitelist and updates your subreddit's markdown (sidebar) when a whitelisted user's status has changed. 


## Example
![http://i.imgur.com/X65FuGl.png](http://i.imgur.com/JSNSsb2.png)

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


