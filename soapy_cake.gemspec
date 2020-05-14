# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'soapy_cake/version'

Gem::Specification.new do |spec|
  spec.name          = 'soapy_cake'
  spec.version       = SoapyCake::VERSION
  spec.authors       = ['ad2games GmbH']
  spec.email         = ['developers@ad2games.com']
  spec.summary       = 'Simple client for the CAKE API'
  spec.description   = 'Simple client for the CAKE API (http://getcake.com)'
  spec.homepage      = 'http://ad2games.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'retryable'
  spec.add_dependency 'saxerator'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
