# Usage :
# Baidu::GetPostSentimentJob.perform_now(post)

class Baidu::GetPostSentimentJob < ApplicationJob
  queue_as :baidu

  def perform(post)
    Baidu::GetSentimentJob.perform_now(post)
    Rails.logger.info { "Scheduling Baidu::GetSentimentJob for comments in Post #{post.dcard_id}" }
    post.comments.find_each { |comment| Baidu::GetSentimentJob.perform_later(comment) }
  end
end
