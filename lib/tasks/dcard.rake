namespace :dcard do
  desc '持續取得新貼文（非學校）'
  task get_posts: :environment do
    require 'sidekiq/api'
    pending_jobs = Sidekiq::Queue.new
    forums = Forum.where(is_school: false)
    loop do
      next if pending_jobs.size <= 0

      forums.each do |forum|
        Dcard::GetForumPostsJob.perform_later(forum)
      end
    end
  end

  desc '取得已抓取貼文的新留言'
  task get_comments: :environment do
    Post.not_removed.where('comment_count > 0').where(comments_count: 0).find_each do |post|
      Dcard::GetPostCommentsJob.perform_later(post)
    end
    Post.not_removed.where('comment_count != comments_count').find_each do |post|
      Dcard::GetPostCommentsJob.perform_later(post)
    end
  end
end
