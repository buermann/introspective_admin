$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "introspective_admin/version"
require "introspective_admin/base"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "introspective_admin"
  s.version     = IntrospectiveAdmin::VERSION
  s.authors     = ["Josh Buermann"]
  s.email       = ["buermann@gmail.com"]
  s.homepage    = "https://github.com/buermann/introspective_admin"
  s.summary     = "Set up basic ActiveAdmin screens for an ActiveRecord model."
  s.description = "Set up basic ActiveAdmin screens for an ActiveRecord model."
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n").sort
  s.test_files    = `git ls-files -- spec/*`.split("\n")

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'sass-rails'

  if RUBY_PLATFORM == 'java'
    s.add_development_dependency "jdbc-sqlite3"
    s.add_development_dependency "activerecord-jdbc-adapter"
  else
    s.add_development_dependency "sqlite3"
    if RUBY_VERSION > '2.0.0'
      s.add_development_dependency 'byebug'
    end
  end
  s.add_development_dependency "rspec-rails", '>= 3.0'
  s.add_development_dependency 'devise'
  s.add_development_dependency 'devise-async'
  s.add_development_dependency 'machinist'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rufus-mnemo'

end

