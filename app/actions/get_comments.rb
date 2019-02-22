module App::Actions
  extend self
  def get_comments
    Post.not_removed.where('comment_count > 0').where(comments_count: 0).find_each do |post|
      CommentsCrawler.perform_async(post.id)
    end
    Post.not_removed.where('comment_count != comments_count').find_each do |post|
      CommentsCrawler.perform_async(post.id)
    end
  end
end
