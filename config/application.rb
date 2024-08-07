require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CisLifeMain
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = Rails.env
    config.active_job.queue_name_delimiter = "_"

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://localhost:6379/0' }
      Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes.to_i
    end

    Sidekiq.configure_server do |config|
      config.redis = { url: "redis://localhost:6379/0" }
      Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes.to_i
      Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes.to_i
    end

    # Configuration for the application, engines, and railties goes here.
    # re
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Singapore"
    config.active_record.default_timezone = :local
    # config.eager_load_paths << Rails.root.join("extras")
    # config.app_generators.scaffold_controller = :scaffold_controller
    config.generators do |g|
      g.scaffold_controller :scaffold_controller
      g.helper false
      g.test_framework false
      g.decorator false
    end
    config.autoload_paths += %W(#{config.root}/app/services)
    config.global_id_signed = true
  end
end
