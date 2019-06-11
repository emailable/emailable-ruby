# frozen_string_literal: true

$LOAD_PATH.unshift(::File.join(::File.dirname(__FILE__), 'lib'))

require 'blazeverify/version'

Gem::Specification.new do |s|
  s.name = 'blazeverify'
  s.version = BlazeVerify::VERSION
  s.summary = 'Ruby bindings for the Blaze Verify API'
  s.description = 'Email Verification that’s astonishingly easy and low-cost.'
  s.homepage = 'https://blazeverify.com'
  s.author = 'Blaze Verify'
  s.email = 'support@blazeverify.com'
  s.license = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map do |f|
    ::File.basename(f)
  end
  s.require_paths = ['lib']

  s.add_dependency 'faraday', '~> 0.13'
  s.add_dependency 'faraday_middleware'
  s.add_dependency 'net-http-persistent'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'minitest-reporters'
end
