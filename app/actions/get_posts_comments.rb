module App::Actions
  def get_posts_comments
    Post.not_removed.where('comment_count > 0').where(comments_count: 0).find_each do |post|
      CommentsCrawler.perform_async(post.id)
    end
  end
end
