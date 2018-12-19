require_relative 'config/boot'

# add activerecord migrations task
StandaloneMigrations::Tasks.load_tasks

desc '進入互動模式'
task run: :environment do
  App::Actions.run
end
