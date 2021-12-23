# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bool_attr_accessor/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.5.0'

  spec.name          = 'bool_attr_accessor'
  spec.version       = BoolAttrAccessor::VERSION
  spec.authors       = ['Marc Rohloff']

    spec.summary     = 'A gem for creating boolean attributes.'
  spec.description   = 'bool_attr_accessor is a gem for creating boolean style attributes.'
  spec.homepage      = 'https://github.com/marcrohloff/bool_attr_accessor'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'benchmark-ips'
  spec.add_development_dependency 'benchmark-memory'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-lcov'
end
