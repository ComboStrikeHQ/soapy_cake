# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'soapy_cake/version'

Gem::Specification.new do |spec|
  spec.name          = "soapy_cake"
  spec.version       = SoapyCake::VERSION
  spec.authors       = ["Helge Rausch"]
  spec.email         = ["developers@ad2games.com"]
  spec.summary       = %q{Simple client for the CAKE API}
  spec.description   = %q{Simple client for the CAKE API (http://getcake.com)}
  spec.homepage      = "http://ad2games.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.0.0"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "debugger"
end
