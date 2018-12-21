require_relative 'config/boot'

# add activerecord migrations task
StandaloneMigrations::Tasks.load_tasks

desc '進入互動模式'
task run: :environment do
  App::Actions.run
end

namespace :run do
  desc '爬取還未被刪除且留言數大於0的貼文留言'
  task get_comments: :environment do
    App::Actions.get_comments
  end
end
