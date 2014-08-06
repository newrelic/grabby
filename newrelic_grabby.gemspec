# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'newrelic_grabby/version'

Gem::Specification.new do |spec|
  spec.name          = "newrelic_grabby"
  spec.version       = NewRelic::Grabby::VERSION
  spec.authors       = ["Lew Cirne"]
  spec.email         = ["lew@newrelic.com"]
  spec.description   = "Prototype for automatic custom attribute instrumentation for New Relic Insights"
  spec.summary       = "Prototype for automatic custom attribute instrumentation for New Relic Insights"
  spec.homepage      = "http://newrelic.com/insights"
  spec.license       = "New Relic"

  spec.add_dependency "newrelic_rpm", "~> 3.9.1"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
