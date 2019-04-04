class GetCommentsJob < ApplicationJob
  queue_as :default

  def perform
    Post.not_removed.where('comment_count > 0').where(comments_count: 0).find_each do |post|
      Dcard::PostCrawler.perform_later(post.id)
    end
    Post.not_removed.where('comment_count != comments_count').find_each do |post|
      Dcard::PostCrawler.perform_later(post.id)
    end
  end
end
