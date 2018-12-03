# require all gems in Gemfile
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
# activerecord migrations task
StandaloneMigrations::Tasks.load_tasks
# load environment variables from .env
require 'dotenv/load'

desc '進入互動模式'
task run: :environment do
  require_relative 'app'
  App.run
end
