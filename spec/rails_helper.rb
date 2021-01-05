require 'spec_helper'


ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
# require 'capybara/poltergeist'
require "selenium/webdriver"
# require 'phantomjs'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
# Capybara.register_driver :poltergeist do |app|
#   Capybara::Poltergeist::Driver.new(app,:phantomjs_options => ['--debug=no', '--load-images=yes', '--ignore-ssl-errors=yes', '--ssl-protocol=TLSv1'],  js_errors: false)
# end

# Capybara.register_driver :chrome do |app|
#   Capybara::Selenium::Driver.new(app, browser: :chrome)
# end


Capybara.register_driver :windows_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome()
  puts 'Current driver (windows_chrome) requires chromedriver to be launched from windows (C:\dev\chromedriver>chromedriver)'
  Capybara::Selenium::Driver.new(app,browser: :chrome, url: 'http://localhost:9515',
                                 desired_capabilities: capabilities
  )
end

Capybara.javascript_driver = :windows_chrome
Capybara.default_max_wait_time = 5 # Seconds
# Capybara.default_selector = :xpath
# Capybara.javascript_driver = :poltergeist
# Capybara.current_driver = :poltergeist
# Capybara.default_max_wait_time = 5


  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
  config.include FeatureHelpers, type: :feature
  config.include ActiveStorageHelpers
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.include Capybara::DSL

  config.filter_rails_from_backtrace!
  config.after(:all) do
    FileUtils.rm_rf("#{Rails.root}/tmp/storage")
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
