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
    config.active_job.queue_name_delimiter = '_'

    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://localhost:6379/15516' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://localhost:6379/15516' }
    end


    # Configuration for the application, engines, and railties goes here.
    #re
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Singapore'
    config.active_record.default_timezone = :local
    # config.eager_load_paths << Rails.root.join("extras")
    config.app_generators.scaffold_controller = :scaffold_controller
    config.autoload_paths += %W(#{config.root}/app/services)
    config.active_job.queue_adapter = :sidekiq

  end
end
