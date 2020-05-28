# frozen_string_literal: true

RouteTranslator.config do |config|
  config.available_locales = %i[en cy]
  config.verify_host_path_consistency = true

  config.host_locales = {
    Rails.configuration.cy_host => :cy,
    Rails.configuration.en_host => :en,
  }
end
