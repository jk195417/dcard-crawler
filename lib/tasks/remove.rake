namespace :remove do
  desc '刪除用不到的貼文'
  task useless_posts: :environment do
    RemoveUselessPostsJob.perform_now
  end

  desc '刪除用不到的留言'
  task useless_comments: :environment do
    RemoveUselessCommentsJob.perform_now
  end
end
