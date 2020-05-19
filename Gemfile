# frozen_string_literal: true

ruby File.read(".ruby-version").strip

source "https://rubygems.org"

gem "asset_sync"
gem "bootsnap", "~> 1"
gem "fog-aws"
gem "govuk_app_config", "~> 2.2.0"
gem "govuk_publishing_components", "~> 21.47.0"
gem "lograge"
gem "pg", "~> 1"
gem "puma", "~> 4.3"
gem "rack_session_access", "~> 0.2"
gem "rails", "~> 6.0.3"

gem "sass-rails", "< 6"
gem "sentry-raven", "~> 3.0"
gem "uglifier", "~> 4.2"

group :development do
  gem "listen", "~> 3"
end

group :test do
  gem "apparition", "~> 0.5.0", require: false
  gem "capybara", "~> 3.32.2", require: false
  gem "mini_racer", "~> 0.2"
  gem "selenium-webdriver", "~> 3.142"
  gem "simplecov", "~> 0.16"
  gem "timecop"
end

group :development, :test do
  gem "awesome_print", "~> 1.8"
  gem "byebug", "~> 11"
  gem "foreman", "~> 0.87.1"
  gem "govuk_test", "~> 1.0"
  gem "jasmine"
  gem "jasmine_selenium_runner", require: false
  gem "pry", "~> 0.13.1"
  gem "pry-rails", "~> 0.3.9"
  gem "rails-controller-testing", "~> 1.0"
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop-govuk"
  gem "scss_lint-govuk"
  gem "webdrivers", "~> 4.3"
end
