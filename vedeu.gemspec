# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'vedeu/version'

Gem::Specification.new do |spec|
  spec.name          = 'vedeu'
  spec.version       = Vedeu::VERSION
  spec.authors       = ['Gavin Laking']
  spec.email         = ['gavinlaking@gmail.com']
  spec.summary       = 'A terminal case of wonderland.'
  spec.description   = 'A GUI framework written in Ruby for building ' \
                       'terminal/console applications.'
  spec.homepage      = 'https://github.com/gavinlaking/vedeu'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',            '~> 1.8'
  spec.add_development_dependency 'guard',              '2.12.6'
  spec.add_development_dependency 'guard-bundler',      '2.1.0'
  spec.add_development_dependency 'guard-minitest',     '2.4.4'
  spec.add_development_dependency 'inch',               '0.6.2'
  spec.add_development_dependency 'minitest',           '5.7.0'
  spec.add_development_dependency 'minitest-reporters', '1.0.17'
  spec.add_development_dependency 'mocha',              '1.1.0'
  spec.add_development_dependency 'pry',                '0.10.1'
  spec.add_development_dependency 'pry-byebug',         '3.1.0'
  spec.add_development_dependency 'rubocop',            '0.32.0'
  spec.add_development_dependency 'ruby-prof',          '0.15.8'
  spec.add_development_dependency 'simplecov',          '0.10.0'
  spec.add_development_dependency 'simplecov-console',  '0.2.0'
  spec.add_development_dependency 'yard',               '0.8.7.6'

  spec.add_dependency 'rake', '~> 10.4'
end
