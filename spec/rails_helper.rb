# frozen_string_literal: true

require 'coveralls'
require 'byebug'
require 'rails-controller-testing'
Coveralls.wear!('rails')
ENV['RAILS_ENV'] = 'test'
require File.expand_path('dummy/config/environment', __dir__)
require 'rspec/rails'
Dir[Rails.root.join('../support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  # config.include Devise::TestHelpers, type: :controller
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.expect_with(:rspec) { |c| c.syntax = :should }
end

RSpec::Mocks.configuration.allow_message_expectations_on_nil = true

# Devise isn't initializing properly in the dummy app, stub it out for now.
# Devise.token_generator ||= Devise::TokenGenerator.new(Devise::CachingKeyGenerator.new(Devise::KeyGenerator.new(Devise.secret_key)))
module Devise
  class Mailer
    def self.confirmation_instructions(*_args)
      Devise::Mailer.new
    end

    def deliver; end

    def deliver_now; end
  end
end
