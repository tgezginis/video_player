require 'spec_helper'

describe VideoPlayer do

  describe "existing API" do
    let(:parser) { VideoPlayer::Parser.new('https://www.youtube.com/watch?v=12345678') }

    it "passes the player method to an instance of VideoPlayer::Parser" do
      expect(VideoPlayer::Parser).to receive(:new).once.and_return(VideoPlayer::Parser.new('url'))
      VideoPlayer::player('https://www.youtube.com/watch?v=12345678')
    end
  end

  describe "selecting video embed method" do

    let(:width) { %|width="#{VideoPlayer::Parser::DefaultWidth}"| }
    let(:height) { %|height="#{VideoPlayer::Parser::DefaultHeight}"| }
    let(:attributes) { %|frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen| }

    context "youtube links" do

      let(:youtube_urls) { [
        'http://youtube.com/watch?v=abcde12345',
        'http://youtu.be/abcde12345',
        'http://youtube.com/watch?feature=player_embedded&v=abcde12345',
        'https://youtube.com/watch?v=abcde12345',
        'https://youtu.be/abcde12345',
        'https://youtube.com/watch?feature=player_embedded&v=abcde12345'
      ]}

      it "returns a valid embed code" do
        src = "//www.youtube.com/embed/abcde12345?autoplay=0&rel=0"
        code = %|<iframe src="#{src}" #{width} #{height} #{attributes}></iframe>|

        url = 'https://youtube.com/watch?feature=player_embedded&v=abcde12345'
        expect(VideoPlayer.player(url, VideoPlayer::Parser::DefaultWidth, VideoPlayer::Parser::DefaultHeight, false)).to eq(code)
      end

      it "returns a valid embed code with disable autoplay" do
        src = "//www.youtube.com/embed/123123123?autoplay=0&rel=0"
        code = %|<iframe src="#{src}" #{width} #{height} #{attributes}></iframe>|

        url = 'https://youtube.com/watch?feature=player_embedded&v=123123123'
        expect(VideoPlayer.player(url, VideoPlayer::Parser::DefaultWidth, VideoPlayer::Parser::DefaultHeight, false)).to eq(code)
      end
    end

    context "vimeo links" do
      let(:vimeo_urls) { [
        'http://vimeo.com/abcde12345?autoplay=0&rel=0',
        'http://www.vimeo.com/abcde12345',
        'https://vimeo.com/abcde12345',
        'https://www.vimeo.com/abcde12345'
      ]}

      it "returns a valid embed code" do
        src = "//player.vimeo.com/video/abcde12345?autoplay=0"
        code = %|<iframe src="#{src}" #{width} #{height} #{attributes}></iframe>|

        url = vimeo_urls.first
        expect(VideoPlayer.player(url, VideoPlayer::Parser::DefaultWidth, VideoPlayer::Parser::DefaultHeight, false)).to eq(code)
      end

      it "returns a valid autoplay embed code" do
        src = "//player.vimeo.com/video/abcde12345?autoplay=1"
        code = %|<iframe src="#{src}" #{width} #{height} #{attributes}></iframe>|

        url = vimeo_urls.first
        expect(VideoPlayer.player(url)).to eq(code)
      end

      it "returns a valid embed video URL" do
        embedded_url = "//player.vimeo.com/video/abcde12345?autoplay=1"

        vimeo_urls.each do |test_url|
          expect(VideoPlayer.embedded_url(test_url)).to eq(embedded_url)
        end
      end
    end

    context "izlesene links" do

      let(:izlesene_urls) { [
        'http://izlesene.com/video/abcde-abcde-abcde-abcde-abcde/12345678',
        'http://www.izlesene.com/video/abcde-abcde-abcde-abcde-abcde/12345678'
      ]}

      it "returns a valid embed code" do
        src = "//www.izlesene.com/embedplayer/12345678/?autoplay=0&showrel=0&showinfo=0"
        code = %|<iframe src="#{src}" #{width} #{height} #{attributes}></iframe>|

        url = 'http://izlesene.com/video/abcde-abcde-abcde-abcde-abcde/12345678'
        expect(VideoPlayer.player(url, VideoPlayer::Parser::DefaultWidth, VideoPlayer::Parser::DefaultHeight, false)).to eq(code)
      end

      it "returns a valid autoplay embed code" do
        src = "//www.izlesene.com/embedplayer/12345678/?autoplay=1&showrel=0&showinfo=0"
        code = %|<iframe src="#{src}" #{width} #{height} #{attributes}></iframe>|

        url = 'http://izlesene.com/video/abcde-abcde-abcde-abcde-abcde/12345678'
        expect(VideoPlayer.player(url)).to eq(code)
      end

    end

    context "wistia links" do

      let(:wistia_urls) { [
        'https://company.wistia.com/medias/12345678'
      ]}

      it "returns a valid embed code" do
        src = "//fast.wistia.net/embed/iframe/12345678/?autoplay=0&showrel=0&showinfo=0"
        code = %|<iframe src="#{src}" #{width} #{height} #{attributes}></iframe>|

        url = 'https://company.wistia.com/medias/12345678'
        expect(VideoPlayer.player(url, VideoPlayer::Parser::DefaultWidth, VideoPlayer::Parser::DefaultHeight, false)).to eq(code)
      end

      it "returns a valid autoplay embed code" do
        src = "//fast.wistia.net/embed/iframe/12345678/?autoplay=1&showrel=0&showinfo=0"
        code = %|<iframe src="#{src}" #{width} #{height} #{attributes}></iframe>|

        url = 'https://company.wistia.com/medias/12345678'
        expect(VideoPlayer.player(url)).to eq(code)
      end

    end
  end

end
