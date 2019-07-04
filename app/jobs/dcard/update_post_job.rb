# Usage :
# Dcard::UpdatePostJob.perform_now(post.id)

class Dcard::UpdatePostJob < ApplicationJob
  queue_as :default

  def perform(id)
    post = ::Post.find id
    post_crawler = Dcard::Post.new(post.dcard_id)
    begin
      new_post = post_crawler.to_record # 可能因為被刪除的留言導致 TypeError
      attributes = new_post.attributes
      %w[id forum_id comments_count reviews_count].each { |key| attributes.delete(key) }
    rescue TypeError
      if post_crawler.data.fetch('error') { nil }.to_i == 1202
        attributes = { removed: post_crawler.data.fetch('reason') { 'removed' } }
      end
    end
    post.update! attributes
    Dcard::GetPostCommentsJob.perform_now(post)
    # Sentiment analyzing and word embedding analyzing
    Baidu::GetPostSentimentJob.perform_later(post)
    Bert::GetPostEmbeddingJob.perform_later(post)
  end
end
