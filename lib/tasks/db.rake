# Layer - Infrastructure / Task Runner

require 'sinatra/activerecord/rake'

namespace :db do
  desc 'Drop, recreate, migrate, and seed the database (development only)'
  task reset: [:environment] do
    abort('db:reset is not allowed in production!') if ENV['RACK_ENV'] == 'production'
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    puts 'Database reset complete.'
  end

  desc 'Print a summary of the current schema'
  task schema: [:environment] do
    ActiveRecord::Base.connection.tables.sort.each do |table|
      puts "\n#{table.upcase}"
      ActiveRecord::Base.connection.columns(table).each do |col|
        puts "#{col.name.ljust(25)} #{col.sql_type}"
      end
    end
  end
end

task :environment do
  ENV['RACK_ENV'] ||= 'development'
  require_relative '../../config/application'
end