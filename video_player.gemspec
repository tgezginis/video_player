# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'video_player/version'

Gem::Specification.new do |spec|
  spec.name          = "video_player"
  spec.version       = VideoPlayer::VERSION
  spec.authors       = ["Tolga Gezginiş"]
  spec.email         = ["tolga@gezginis.com"]
  spec.summary       = %q{Video player for Youtube and Vimeo}
  spec.description   = %q{Create video player for Youtube and Vimeo videos}
  spec.homepage      = "https://github.com/tgezginis/video_player"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
