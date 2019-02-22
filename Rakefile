require_relative 'config/boot'

# add activerecord migrations task
StandaloneMigrations::Tasks.load_tasks

desc '進入互動模式'
task run: :environment do
  App::Actions.run
end

namespace :run do
  desc '爬取所有論壇的資訊'
  task update_forums: :environment do
    App::Actions.update_forums

  end

  desc '爬取非學校論壇的貼文'
  task get_posts: :environment do
    require 'sidekiq/api'
    pending_jobs = Sidekiq::Queue.new
    while true
      App::Actions.get_posts if pending_jobs.size < 1
    end
  end

  desc '爬取還未被刪除且留言數大於0的貼文留言'
  task get_comments: :environment do
    App::Actions.get_comments
  end

  desc '刪除留言數小於10或是已經被移除的貼文'
  task remove_useless_posts: :environment do
    App::Actions.remove_useless_posts
  end

  desc '刪除空白內容的留言與以移除無法獲得內容的留言'
  task remove_useless_comments: :environment do
    App::Actions.remove_useless_comments
  end


  desc '取得留言的 word embeddings'
  task get_comments_embeddings: :environment do
    App::Actions.get_comments_embeddings
  end

end
