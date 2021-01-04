require 'spec_helper'


ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# require "selenium/webdriver"
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'phantomjs'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,:phantomjs_options => ['--debug=no', '--load-images=yes', '--ignore-ssl-errors=yes', '--ssl-protocol=TLSv1'],  js_errors: false)
end

Capybara.default_selector = :xpath
Capybara.javascript_driver = :poltergeist
Capybara.current_driver = :poltergeist
Capybara.default_max_wait_time = 5

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
  config.include FeatureHelpers
  config.include ActiveStorageHelpers
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

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
