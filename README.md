# Video player for Youtube and Vimeo
[![Gem Version](https://badge.fury.io/rb/video_player.svg)](http://badge.fury.io/rb/video_player)

Create video player for Youtube and Vimeo videos for Ruby.

And it may support more video hoster with your [contributions](#contributing).

## Installation

Add it to your Gemfile:

```ruby
gem 'video_player'
```

and run on terminal:

    $ bundle

or install the gem on terminal.

    $ gem install video_player

## Parameters

**url**

> Youtube or Vimeo video link
> http://www.youtube.com/watch?v=iEPTlhBmwRg
> or
> http://vimeo.com/101419884

**width** *(default  = 420)*
**height** *(default  = 315)*
**autoplay** *(default  = true)* - works only on Youtube


## Usage

```ruby
require 'video_player'
VideoPlayer::player("http://vimeo.com/101419884")
# returns iframe player from Vimeo video
# <iframe src=\"//player.vimeo.com/video/101419884\" width=\"420\" height=\"315\" frameborder=\"0\"></iframe>

VideoPlayer::player("http://www.youtube.com/watch?v=iEPTlhBmwRg", "1200", "800", true)
# returns iframe player which has 1200px width and 800px height with autoplay from Youtube video
# <iframe width=\"1200\" height=\"800\" src=\"//www.youtube.com/embed/iEPTlhBmwRg?autoplay=1&rel=0\" frameborder=\"0\" allowfullscreen></iframe>
```


**Rails 4**
```ruby
VideoPlayer::player("http://vimeo.com/101419884")
# returns iframe player from Vimeo video
# <iframe src=\"//player.vimeo.com/video/101419884\" width=\"420\" height=\"315\" frameborder=\"0\"></iframe>

VideoPlayer::player("http://www.youtube.com/watch?v=iEPTlhBmwRg", "1200", "800", true)
# returns iframe player which has 1200px width and 800px height with autoplay from Youtube video
# <iframe width=\"1200\" height=\"800\" src=\"//www.youtube.com/embed/iEPTlhBmwRg?autoplay=1&rel=0\" frameborder=\"0\" allowfullscreen></iframe>
```

It gets you only raw data. You must handle it on erb, haml, slim, etc for output without HTML escaping.

```ruby
video = VideoPlayer::player("http://vimeo.com/101419884")

# erb
<%= video.html_safe %>

# haml, slim
= video.html_safe
# or
== video
```


<a name="contributing"></a>
## Contributing
1. Fork it ( https://github.com/tgezginis/video_player/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
