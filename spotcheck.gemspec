$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'spotcheck/version'

Gem::Specification.new do |s|
  s.name        = 'spotcheck'
  s.version     = Spotcheck::VERSION
  s.authors     = ['Maxime Bedard']
  s.email       = ['maxim3.bedard@gmail.com']
  s.homepage    = 'http://github.com/maximebedard/spotcheck'
  s.summary     = 'Opinionated parameters validation, even more than rails/strong_parameters'
  s.description = 'Add parameter validation over rails/strong_parameters'
  s.license     = 'MIT'

  s.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.required_ruby_version = '>= 2.0.0'
  s.add_dependency 'activesupport'
  s.add_dependency 'actionpack'
  s.add_dependency 'activemodel'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'pry-byebug'
end
