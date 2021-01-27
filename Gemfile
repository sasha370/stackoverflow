source 'https://rubygems.org'

ruby "2.7.2"

gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem "haml-rails"
gem 'devise'
gem 'devise-bootstrap-views'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'twitter-bootstrap-rails'
gem 'jquery-rails'
gem 'aws-sdk-s3', require: false
gem "cocoon"
gem "font-awesome-rails"
gem 'gon'
gem 'faker'
gem 'rake'
gem 'omniauth', '~> 1.9', '>= 1.9.1'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'omniauth-vkontakte'
gem 'omniauth-twitter'
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers'
gem 'oj'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'whenever', require: false
gem 'mysql2', '~> 0.4'
gem 'thinking-sphinx', '~> 5.1'
gem 'ed25519'
gem 'bcrypt_pbkdf'
gem 'mini_racer'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'dotenv-rails', :require => 'dotenv/rails-now'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem "capistrano-sidekiq", git: "https://github.com/rwojnarowski/capistrano-sidekiq.git", require: false
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'capybara-email'
  gem 'poltergeist'
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
  gem 'webdrivers', '~> 4.0', require: false
  gem 'shoulda-matchers'
  gem "rails-controller-testing"
  gem 'launchy'
  gem 'database_cleaner-active_record'
end
