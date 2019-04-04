namespace :dcard do
  desc '取得所有論壇的資訊'
  task get_forums: :environment do
    GetForumsJob.perform_now
  end

  desc '持續取得新貼文'
  task get_posts: :environment do
    require 'sidekiq/api'
    pending_jobs = Sidekiq::Queue.new
    loop do
      GetPostsJob.perform_now if pending_jobs.size <= 0
    end
  end

  desc '取得貼文的留言'
  task get_comments: :environment do
    GetCommentsJob.perform_now
  end
end
