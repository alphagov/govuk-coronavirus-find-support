# frozen_string_literal: true

RouteTranslator.config do |config|
  config.host_locales = {
    Rails.configuration.cy_host => :cy,
    Rails.configuration.en_host => :en,
  }
end
