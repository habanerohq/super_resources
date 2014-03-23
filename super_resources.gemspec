# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'super_resources/version'

Gem::Specification.new do |gem|
  gem.name          = "super_resources"
  gem.version       = SuperResources::VERSION
  gem.authors       = ["Ben Caldwell", "Mark Ratjens"]
  gem.email         = ["ben@habanerohq.com", "mark@habanerohq.com"]
  gem.description   = %q{SuperResources DRYs up your controller code.}
  gem.summary       = %q{SuperResources DRYs up your controller code.}
  gem.homepage      = "https://github.com/habanerohq/super_resources"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'responders'
end
