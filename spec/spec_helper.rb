# frozen_string_literal: true

require "byebug"
require "rack_session_access/capybara"
require "simplecov"
require "capybara/apparition"

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }
SimpleCov.start

Capybara.javascript_driver = :apparition

RSpec.configure do |config|
  config.expose_dsl_globally = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
  config.include Capybara::DSL, type: :request
  config.include Capybara::RSpecMatchers, type: :request
  config.before :each, :js do
    page.driver.add_headers("SMOKE_TEST" => "true")
  end
end
