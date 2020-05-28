# frozen_string_literal: true

require "byebug"
require "rack_session_access/capybara"
require "simplecov"
require "capybara/apparition"
require "webmock/rspec"

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
    WebMock.allow_net_connect!
    page.driver.add_headers("SMOKE_TEST" => "true")
  end
  config.after :each, :js do
    WebMock.disable_net_connect!
  end
end

ENV["DATA_EXPORT_BASIC_AUTH_USERNAME"] ||= "testuser"
ENV["DATA_EXPORT_BASIC_AUTH_PASSWORD"] ||= SecureRandom.hex
