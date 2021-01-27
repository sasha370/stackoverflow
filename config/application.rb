require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

if ['development', 'test'].include? ENV['RAILS_ENV']
  Dotenv::Railtie.load
end

HOSTNAME = ENV['HOSTNAME']
module Stackoverflow
  class Application < Rails::Application
    config.load_defaults 6.0
    config.time_zone = 'Moscow'
    config.active_record.default_timezone = :local
    config.i18n.fallbacks = true
    ActiveSupport::Deprecation.silenced = true
    config.active_storage.replace_on_assign_to_many = false
    config.active_job.queue_adapter = :sidekiq
    config.action_mailer.default_url_options = { host: 'stackoverflow.ru' }

    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false,
                       controller_specs: true
    end
  end
end
