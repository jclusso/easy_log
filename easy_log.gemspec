# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easy_log/version'

Gem::Specification.new do |s|
  s.name          = 'easy_log'
  s.version       = EasyLog::VERSION
  s.authors       = ['Jarrett Lusso', 'Daniel Arnold']
  s.email         = ['jclusso@gmail.com', 'darnold8@gmail.com']

  s.summary       = 'EasyLog makes it easy to output descriptive logs'
  s.homepage      = 'http://github.com/jclusso/easy_log'
  s.license       = 'GNU GPL v3.0'

  s.files         = Dir['LICENSE.txt', 'README.md', 'lib/**/*']
  s.require_paths = ["lib"]

  s.add_development_dependency 'bundler', '~> 1.10'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.3.0'

  s.add_dependency 'binding_of_caller', '~> 0.7.2'
end
