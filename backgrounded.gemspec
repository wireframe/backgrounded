# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'backgrounded/version'

Gem::Specification.new do |spec|
  spec.name        = 'backgrounded'
  spec.version     = Backgrounded::VERSION
  spec.authors     = ['Ryan Sonnek']
  spec.email       = ['ryan@codecrate.com']

  spec.summary     = %q{Simple API to perform work in the background}
  spec.description = %q{Execute any ActiveRecord Model method in the background}
  spec.homepage    = 'http://github.com/wireframe/backgrounded'

  spec.add_runtime_dependency 'rails', '>= 3.0.0'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', "~> 3.0"
  spec.add_development_dependency 'sqlite3-ruby', '>= 1.3.2'
  spec.add_development_dependency 'pry', '>= 0.9.12'
  spec.add_development_dependency 'test_after_commit'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
