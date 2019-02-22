module App::Actions
  extend self
  def remove_useless_posts(removed: true, comment_count_less_then: 10)
    already_removed_posts = Post.where(comments_count: 0).where.not(removed: nil)
    already_removed_posts.destroy_all
    small_comment_count_posts = Post.where('comment_count < ?', comment_count_less_then)
    small_comment_count_posts.destroy_all
    # Forum.all.each { |f| Forum.reset_counters(f.id, :posts_count) }
  end
end
