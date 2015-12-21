# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'brigadier/version'

Gem::Specification.new do |spec|
  spec.name          = 'brigadier'
  spec.version       = Brigadier::VERSION
  spec.authors       = ['Ash McKenzie']
  spec.email         = ['ash@the-rebellion.net']

  spec.summary       = 'Brigadier - Take control of your command line'
  spec.description   = 'Brigadier is a DSL that provides the ability to create complex command line tools with support for - sub commands, arguments, options and toggles'
  spec.homepage      = 'https://github.com/ashmckenzie'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
