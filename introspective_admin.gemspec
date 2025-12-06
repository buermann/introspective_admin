# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'introspective_admin/version'
require 'introspective_admin/base'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'introspective_admin'
  s.version     = IntrospectiveAdmin::VERSION
  s.authors     = ['Josh Buermann']
  s.email       = ['buermann@gmail.com']
  s.homepage    = 'https://github.com/buermann/introspective_admin'
  s.summary     = 'Set up basic ActiveAdmin screens for an ActiveRecord model.'
  s.description = 'Set up basic ActiveAdmin screens for an ActiveRecord model.'
  s.license     = 'MIT'

  s.files = `git ls-files`.split("\n").sort

  s.required_ruby_version = '>= 3.0', '< 4'

  s.add_dependency 'activeadmin'
  s.add_dependency 'sass'
  s.add_dependency 'sass-rails'

  s.metadata['rubygems_mfa_required'] = 'true'
end
