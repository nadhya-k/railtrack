# Layer - Test Infrastructure

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
    minimum_coverage 80
  end
end

ENV['RACK_ENV'] = 'test'

require_relative '../config/application'
require 'rspec'
require 'rack/test'
require 'factory_bot'
require 'faker'
require 'timecop'
require 'database_cleaner/active_record'

Dir[File.join(__dir__, 'support', '**', '*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Rack::Test::Methods

  config.include(Module.new do
    def app
      RailTrack::Application
    end
  end)

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end

  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.order = :random
  config.warnings = true
end