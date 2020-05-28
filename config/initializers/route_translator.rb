# frozen_string_literal: true

RouteTranslator.config do |config|
  config.available_locales = %i[en cy]
  config.verify_host_path_consistency = false

  config.host_locales = {
    Rails.configuration.en_host => :en,
    Rails.configuration.cy_host => :cy,
  }
end
