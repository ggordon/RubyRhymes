# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_rhymes/version'

Gem::Specification.new do |s|
  s.name        = 'ruby_rhymes'
  s.version     = RubyRhymes::VERSION
  s.date        = '2011-10-11'
  s.summary     = 'A gem for producing poetry for the rest of us'
  s.description = 'A gem for rhyming words and counting syllables on phrases'
  s.authors     = ['Vlad Shulman', 'Thomas Kielbus', 'Gary Gordon']
  s.email       = 'vladshulman@gmail.com'
  s.files       = `git ls-files`.split($/)
  s.homepage    = 'https://github.com/ggordon/RubyRhymes'

  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.5'
  s.add_development_dependency 'rake', '>= 10.0'
  s.add_development_dependency 'minitest-reporters'
end
