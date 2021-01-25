require 'rails_helper'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:suite) do
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:each, sphinx: true) do
    DatabaseCleaner.strategy = :truncation
    ThinkingSphinx::Test.index
  end
end
