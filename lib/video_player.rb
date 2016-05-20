require "video_player/version"

module VideoPlayer
  def self.player(*args)
    VideoPlayer::Parser.new(*args).embed_code
  end

  class Parser
    DefaultWidth = '420'
    DefaultHeight = '315'
    DefaultAutoPlay = true

    YouTubeRegex  = /\A(https?:\/\/)?(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?/i
    VimeoRegex    = /\Ahttps?:\/\/(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?/i
    IzleseneRegex = /\Ahttp:\/\/(?:.*?)\izlesene\.com\/video\/([\w\-\.]+[^#?\s]+)\/(.*)?$/i

    attr_accessor :url, :width, :height

    def initialize(url, width = DefaultWidth, height = DefaultHeight, autoplay = DefaultAutoPlay)
      @url = url
      @width = width
      @height = height
      @autoplay = autoplay
    end

    def embed_code
      case
      when matchdata = url.match(YouTubeRegex)
        youtube_embed(matchdata[4])
      when matchdata = url.match(VimeoRegex)
        vimeo_embed(matchdata[2])
      when matchdata = url.match(IzleseneRegex)
        izlesene_embed(matchdata[2])
      else
        false
      end
    end

    def autoplay
      !!@autoplay ? '1' : '0'
    end

    def iframe_code(src)
      %{<iframe src="#{src}" width="#{width}" height="#{height}" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>}
    end

    def youtube_embed(youtube_id)
      src = "//www.youtube.com/embed/#{youtube_id}?autoplay=#{autoplay}&rel=0"
      iframe_code(src)
    end

    def vimeo_embed(vimeo_id)
      src = "//player.vimeo.com/video/#{vimeo_id}"
      iframe_code(src)
    end

    def izlesene_embed(izlesene_video_id)
      src = "//www.izlesene.com/embedplayer/#{izlesene_video_id}/?autoplay=#{autoplay}&showrel=0&showinfo=0"
      iframe_code(src)
    end
  end
end