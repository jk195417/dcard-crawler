# Usage :
# Baidu::GetPostSentimentJob.perform_now(Post.random.first.id)

class Baidu::GetPostSentimentJob < ApplicationJob
  def perform(id)
    post = Post.find id
    text = post.content&.gsub(URI::DEFAULT_PARSER.make_regexp, '') # remove url
    Rails.logger.info { "Analyzing sentiment of Post #{post.dcard_id}" }
    Baidu::Aip.new.sentiment(text)
    post.comments.find_each do |comment|
      Baidu::GetCommentSentimentJob.perform_now(comment.id)
    end
  end
end
