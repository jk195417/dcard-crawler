require_relative 'bootstrap'

# add activerecord migrations task
StandaloneMigrations::Tasks.load_tasks

# load environment variables from .env
require 'dotenv/load'

desc '進入互動模式'
task run: :environment do
  App.run
end
