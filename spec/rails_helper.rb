require 'coveralls'
Coveralls.wear!('rails')
ENV["RAILS_ENV"] = 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
Dir[Rails.root.join("../support/**/*.rb")].each { |f| require f }


RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.expect_with(:rspec) { |c| c.syntax = :should }
end

# Devise isn't initializing properly in the dummy app, stub it out for now.
Devise.token_generator ||= Devise::TokenGenerator.new(Devise::CachingKeyGenerator.new(Devise::KeyGenerator.new(Devise.secret_key)))
class Devise::Mailer
  def self.confirmation_instructions(a,b,c)
    Devise::Mailer.new
  end
  def deliver
  end
end
