# Layer - Infrastructure / Configuration & Bootstrap
#
# This is the application bootstrap. It runs once at startup and:
#   1. Loads all gems via Bundler
#   2. Reads environment variables (.env in dev, real env vars in production)
#   3. Connects ActiveRecord to PostgreSQL
#   4. Requires all app files in dependency order
#   5. Defines the top-level Sinatra Application with shared middleware
#
# Required by:  config.ru (server startup)
#               spec/spec_helper.rb (test suite)


require 'bundler/setup'

Bundler.require(:default, ENV.fetch('RACK_ENV', 'development').to_sym)

Dotenv.load if %w[development test].include?(ENV.fetch('RACK_ENV', 'development'))


# ----- Database connection -----
DB_CONFIG = YAML.safe_load(
  ERB.new(File.read(File.join(__dir__, 'database.yml'))).result,
  aliases: true
).fetch(ENV.fetch('RACK_ENV', 'development'))

ActiveRecord::Base.establish_connection(DB_CONFIG)

ActiveRecord::Base.logger = Logger.new($stdout) if ENV['RACK_ENV'] == 'development'


# ----- Require application files -----

Dir[File.join(__dir__, '..', 'app', 'models',      '*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, '..', 'app', 'services',    '*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, '..', 'app', 'serializers', '*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, '..', 'app', 'controllers', '*.rb')].sort.each { |f| require f }


# ----- Application class -----

module RailTrack
  class Application < Sinatra::Base
    use Rack::JSONBodyParser

    use StationsController
    use JourneysController
    use BookingsController

    error Sinatra::NotFound do
      content_type :json
      status 404
      Oj.dump({ error: 'Not found' }, mode: :compat)
    end

    error ActiveRecord::RecordNotFound do
      content_type :json
      status 404
      Oj.dump({ error: 'Record not found' }, mode: :compat)
    end

    error do
      content_type :json
      status 500
      Oj.dump({ error: 'Internal server error' }, mode: :compat)
    end

    get '/health' do
      content_type :json
      Oj.dump({ status: 'ok', env: ENV.fetch('RACK_ENV', 'development') },
              mode: :compat)
    end
  end
end