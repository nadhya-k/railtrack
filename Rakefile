# Layer - Infrastructure / Task Runner

# The root Rakefile loads the application environment and any custom tasks defined in lib/tasks/. This file is required by `bundle exec rake db:migrate` etc.

ENV['RACK_ENV'] ||= 'development'

require_relative 'config/application'
require 'sinatra/activerecord/rake'

# Load all custom rake tasks from lib/tasks/
Dir[File.join(__dir__, 'lib', 'tasks', '**', '*.rake')].each { |f| load f }