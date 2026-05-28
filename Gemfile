# Layer - Infrastructure and Dependency Management

# This file declares every Ruby gem library that this project is dependent on.
# This file is read by `bundle install, after which all gems at the pinned version are installed.# `Gemfile.lock` records the exact resolved versions so every developer and CI environment runs identical code.


source 'https://rubygems.org'
ruby '4.0.5'

# ----- Web Framework Libraries -----

gem 'sinatra', '~> 3.2'
gem 'sinatra-contrib', '~> 3.2'
gem 'puma', '~> 6.4'

# ----- Database Libraries -----

gem 'activerecord', '~> 7.1'
gem 'pg', '~> 1.5'
gem 'sinatra-activerecord', '~>2.0'
gem 'rake', '~> 13.1'

# ----- Serialization Library -----

gem 'oj', '~> 3.16'

# ----- Utilities Library -----

gem 'dotenv', '~> 3.1'


# ----- Test Group -----

group :test do 
    gem 'rspec', '~> 3.13'
    gem 'rack-test', '~> 2.1'
    gem 'database_cleaner-active_record', '~> 2.1'
    gem 'simplecov', '~> 0.22', require: false
    gem 'factory_bot', '~> 6.4'
    gem 'faker', '~> 3.3'
    gem 'timecop', '~> 0.9'
end

group :development, :test do
    gem 'rubocop', '~> 1.64', require: false
    gem 'rubocop-rspec', '~> 3.0', require: false
    gem 'rubocop-performance', '~> 1.21', require: false
end
