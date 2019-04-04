class RemoveUselessPostsJob < ApplicationJob
  queue_as :default

  def perform
    comment_count_less_then = 10
    already_removed_posts = Post.where(comments_count: 0).where.not(removed: nil)
    already_removed_posts.destroy_all
    small_comment_count_posts = Post.where('comment_count < ?', comment_count_less_then)
    small_comment_count_posts.destroy_all
  end
end
