namespace :dcard do
  desc '更新所有論壇'
  task update_forums: :environment do
    Dcard::UpdateForumsJob.perform_now
  end

  desc '持續取得新貼文（非學校）'
  task get_posts: :environment do
    require 'sidekiq/api'
    pending_jobs = Sidekiq::Queue.new
    forums = Forum.where(is_school: false)
    loop do
      next if pending_jobs.size <= 0

      forums.each do |forum|
        Dcard::GetForumPostsJob.perform_later(forum.id)
      end
    end
  end

  desc '取得已抓取貼文的新留言'
  task get_comments: :environment do
    Post.not_removed.where('comment_count > 0').where(comments_count: 0).find_each do |post|
      Dcard::GetPostCommentsJob.perform_later(post.id)
    end
    Post.not_removed.where('comment_count != comments_count').find_each do |post|
      Dcard::GetPostCommentsJob.perform_later(post.id)
    end
  end

  namespace :remove do
    desc '刪除 沒有留言 / 已經被移除 / 留言數太少 的貼文'
    task useless_posts: :environment do
      comment_count_less_then = 10
      no_comments_posts = Post.where(comment_count: nil)
      no_comments_posts.destroy_all
      already_removed_posts = Post.where(comments_count: 0).where.not(removed: nil)
      already_removed_posts.destroy_all
      small_comment_count_posts = Post.where('comment_count < ?', comment_count_less_then)
      small_comment_count_posts.destroy_all
    end

    desc '刪除 已經被移除 / 空白內容 的留言'
    task useless_comments: :environment do
      already_removed_comments = Comment.where(hidden: true, content: nil)
      already_removed_comments.destroy_all
      no_content_comments = Comment.where("(trim(content) = '') is true")
      no_content_comments.destroy_all
    end
  end
end
