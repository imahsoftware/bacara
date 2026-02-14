require_relative 'boot'

require 'csv'
require 'rails/all'
require 'barby'
require 'barby/barcode/gs1_128'
require 'barby/barcode/qr_code'
require 'barby/outputter/png_outputter'
require 'rqrcode'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bacara
  class Application < Rails::Application
    config.app_name = "Bacara"
    config.action_mailer.default_url_options = { host: 'imahsoftware.com' }
    config.action_cable.disable_request_forgery_protection = true
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    #config.active_record.default_timezone = 'America/Bogota'
    config.time_zone = "America/Bogota"
    config.active_record.default_timezone = :local
    config.i18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]
    I18n.config.enforce_available_locales = true
    config.i18n.available_locales = [:es, :en]
    config.i18n.default_locale = :es
    config.exceptions_app = self.routes
    # Mantener el comportamiento antiguo (antes de Rails 5.1)
    config.active_record.time_zone_aware_types = [:datetime]

    # Utilizar el nuevo comportamiento (para futuras versiones de Rails)
    config.active_record.time_zone_aware_types = [:datetime, :time]


    config.second_base.run_with_db_tasks = false

    config.second_base.path = 'db/secondbase'
    config.second_base.config_key = 'secondbase'

    # server de jobs
    config.active_job.queue_adapter = :inline
    #config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] }
    config.cache_store = :redis_store, "redis://localhost:6379/0/cache", { expires_in: 90.minutes }
  end
end
