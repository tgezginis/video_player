require "video_player/version"

module VideoPlayer
  def self.player(*args)
    VideoPlayer::Parser.new(*args).embed_code
  end

  def self.embedded_url(video_url)
    VideoPlayer::Parser.new(video_url).embedded_url
  end

  def self.thumbnail_url(video_url)
    VideoPlayer::Parser.new(video_url).thumbnail_url
  end

  class Parser
    DefaultWidth = '420'
    DefaultHeight = '315'
    DefaultAutoPlay = true

    YouTubeRegex  = /\A(https?:\/\/)?(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?/i
    VimeoRegex    = /\Ahttps?:\/\/(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?/i
    IzleseneRegex = /\Ahttp:\/\/(?:.*?)\izlesene\.com\/video\/([\w\-\.]+[^#?\s]+)\/(.*)?$/i
    WistiaRegex   = /\Ahttps?:\/\/(.+)?(wistia.com|wi.st)\/(medias|embed)\/([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?/i

    # youtube
    #   default: small - 120x90
    #   mqdefault: medium - 320x180
    #   hqdefault: high - 480x360
    #   sddefault: 640x480
    #   maxresdefault: original

    # vimeo
    #   thumbnail_small: 100x75
    #   thumbnail_medium: 200x150
    #   thumbnail_large: 640xauto
    SIZES = {
      small: ['default', 'thumbnail_small'],
      medium: ['mqdefault', 'thumbnail_medium'],
      large: ['sddefault', 'thumbnail_large'],
      max: ['maxresdefault', 'thumbnail_large'],
    }

    {
      youtube:  YouTubeRegex,
      vimeo:    VimeoRegex,
      izlesene: IzleseneRegex,
      wistia:   WistiaRegex,
    }.each do |method_name, regexp|
      define_method("#{ method_name }?") do
        instance_variable_get("@#{ method_name }" ) || instance_variable_set("@#{ method_name }", url.match(regexp))
      end
    end

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
        when matchdata = youtube?
          "//www.youtube.com/embed/#{ video_id }?autoplay=#{ autoplay }&rel=0"
        when matchdata = vimeo?
          # Check for an unlisted code e.g., https://vimeo.com/693890394/4bead26492
          matched_code = url.match(/\d+\/(.+)/)
          matched_code = matched_code[1].split('?').first if matched_code

          "//player.vimeo.com/video/#{ video_id }?autoplay=#{ autoplay }#{ "&h=#{ matched_code }" if matched_code }"
        when matchdata = izlesene?
          "//www.izlesene.com/embedplayer/#{ video_id }/?autoplay=#{ autoplay }&showrel=0&showinfo=0"
        when matchdata = wistia?
          "//fast.wistia.net/embed/iframe/#{ video_id }/?autoplay=#{ autoplay }&showrel=0&showinfo=0"
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

    # size_parameter = { 'small', 'medium', 'large', 'max'}
    def thumbnail_url(size = 'max')
      youtube_size, vimeo_size = SIZES[size.to_sym] || ['sddefault', 'thumbnail_large']

      case
      when youtube? then "https://img.youtube.com/vi/#{ video_id }/#{ youtube_size }.jpg"
      when vimeo? then
        begin
          JSON.parse(URI.open("https://vimeo.com/api/v2/video/#{ video_id }.json").read).first[vimeo_size]
        rescue
          nil
        end
      when izlesene? then Nokogiri::HTML(open(url)).css("meta[property='og:image']").at_css('meta[property="og:image"]')['content']
      end
    end

    def video_id
      @_video_id ||=
        case
        when matchdata = youtube? then matchdata[4]
        when matchdata = vimeo? then matchdata[2]
        when matchdata = izlesene? then matchdata[2]
        when matchdata = wistia? then matchdata[4]
        end
    end
  end
end
