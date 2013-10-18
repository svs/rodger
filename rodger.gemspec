# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rodger/version'

Gem::Specification.new do |spec|
  spec.name          = "rodger"
  spec.version       = Rodger::VERSION
  spec.authors       = ["svs"]
  spec.email         = ["svs@svs.io"]
  spec.description   = %q{Read ledger-cli files with ease in Ruby}
  spec.summary       = %q{Rodger is a ruby API for getting info out of files that can be parsed by ledger-cli}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "hashie"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

end
