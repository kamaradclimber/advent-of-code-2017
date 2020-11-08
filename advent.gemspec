# frozen_string_literal: true

require 'date'

Gem::Specification.new do |spec|
  spec.name          = 'advent'
  spec.version       = if Date.today < Date.new(2020, 12, 1)
                         '0'
                       else
                         Date.day.to_s
                       end
  spec.version       = "#{spec.version}-alpha-#{ENV['TRAVIS_BUILD_NUMBER']}" if ENV['TRAVIS']
  spec.version       = ENV['TRAVIS_TAG'] if ENV['TRAVIS_TAG'] && !ENV['TRAVIS_TAG'].empty?
  spec.authors       = ['Grégoire Seux']
  spec.email         = ['grego_aoc@familleseux.net']

  spec.summary       = 'My repo to store advent of code solution for 2017'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib days]

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop', '= 0.93.0'
end
