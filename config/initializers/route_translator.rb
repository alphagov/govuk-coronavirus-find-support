# frozen_string_literal: true

RouteTranslator.config do |config|
  config.hide_locale = true

  config.host_locales = {
    Rails.configuration.cy_host => :cy,
    Rails.configuration.en_host => :en,
  }
end
