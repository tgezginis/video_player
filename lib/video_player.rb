require "video_player/version"

module VideoPlayer
  def self.player(*args)
    VideoPlayer::Parser.new(*args).embed_code
  end

  def self.embedded_url(video_url)
    VideoPlayer::Parser.new(video_url).embedded_url
  end

  class Parser
    DefaultWidth = '420'
    DefaultHeight = '315'
    DefaultAutoPlay = true

    YouTubeRegex  = /\A(https?:\/\/)?(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?/i
    VimeoRegex    = /\Ahttps?:\/\/(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?/i
    IzleseneRegex = /\Ahttp:\/\/(?:.*?)\izlesene\.com\/video\/([\w\-\.]+[^#?\s]+)\/(.*)?$/i
    WistiaRegex   = /\Ahttps?:\/\/(.+)?(wistia.com|wi.st)\/(medias|embed)\/([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?/i

    attr_accessor :url, :width, :height

    def initialize(url, width = DefaultWidth, height = DefaultHeight, autoplay = DefaultAutoPlay)
      @url = url
      @width = width
      @height = height
      @autoplay = autoplay
    end

    def embedded_url
      @_embedded_url ||=
        case
        when matchdata = url.match(YouTubeRegex)
          "//www.youtube.com/embed/#{matchdata[4]}?autoplay=#{autoplay}&rel=0"
        when matchdata = url.match(VimeoRegex)
          "//player.vimeo.com/video/#{matchdata[2]}?autoplay=#{autoplay}"
        when matchdata = url.match(IzleseneRegex)
          "//www.izlesene.com/embedplayer/#{matchdata[2]}/?autoplay=#{autoplay}&showrel=0&showinfo=0"
        when matchdata = url.match(WistiaRegex)
          "//fast.wistia.net/embed/iframe/#{matchdata[4]}/?autoplay=#{autoplay}&showrel=0&showinfo=0"
        end
    end

    def embed_code
      if embedded_url
        iframe_code
      else
        false
      end
    end

    def autoplay
      !!@autoplay ? '1' : '0'
    end

    def iframe_code
      %{<iframe src="#{embedded_url}" width="#{width}" height="#{height}" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>}
    end
  end
end
