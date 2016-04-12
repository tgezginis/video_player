require "video_player/version"

module VideoPlayer
  def self.player url, width = "420", height = "315", autoplay = true
    if url.include? "youtu"
      regex = /(https?:\/\/)?(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?/
      url.gsub(regex) do
        youtube_id = $4
        if autoplay
          src = "//www.youtube.com/embed/#{youtube_id}?autoplay=1&rel=0"
        else
          src = "//www.youtube.com/embed/#{youtube_id}?autoplay=0&rel=0"
        end
        return %{<iframe width="#{width}" height="#{height}" src="#{src}" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>}
      end
    elsif url.include? "vimeo"
      url.gsub(/https?:\/\/(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?/) do
        vimeo_id = $2
        frameborder = 0
        return %{<iframe src="//player.vimeo.com/video/#{vimeo_id}" width="#{width}" height="#{height}" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>}
      end
    elsif url.include? "izlesene"
      regex = /^http:\/\/(?:.*?)\izlesene\.com\/video\/([\w\-\.]+[^#?\s]+)\/(.*)?$/i
      url.gsub(regex) do
        izlesene_video_id = $2
        if autoplay
          src = "//www.izlesene.com/embedplayer/#{izlesene_video_id}/?autoplay=1&showrel=0&showinfo=0"
        else
          src = "//www.izlesene.com/embedplayer/#{izlesene_video_id}/?autoplay=0&showrel=0&showinfo=0"
        end
        return %{<iframe width="#{width}" height="#{height}" src="#{src}" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>}
      end
    else
      return false
    end
  end
end