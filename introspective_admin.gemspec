$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "introspective_admin/version"
require "introspective_admin/base"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "introspective_admin"
  s.version     = IntrospectiveAdmin::VERSION
  s.authors     = ["josh buermann"]
  s.email       = ["buermann@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of IntrospectiveAdmin."
  s.description = "TODO: Description of IntrospectiveAdmin."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.test_files = Dir["spec/**/*"]

  #s.add_dependency "rails"
  s.add_dependency 'sass-rails'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", '>= 3.0'
  s.add_development_dependency 'machinist'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rufus-mnemo'

  # for the test app
  #s.add_development_dependency 'sidekiq'
  #s.add_development_dependency 'config'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'devise'
  s.add_development_dependency 'devise-async'
  # For compatibility of schema_validations with AR 4.2.1+
  s.add_development_dependency "schema_plus", "2.0.0.pre12"
  s.add_development_dependency "schema_validations"

end

