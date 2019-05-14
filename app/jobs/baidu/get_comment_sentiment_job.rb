# Usage :
# Baidu::GetCommentSentimentJob.perform_now(comment.id)

class Baidu::GetCommentSentimentJob < ApplicationJob
  def perform(id)
    comment = Comment.find id
    text = comment.content&.gsub(URI::DEFAULT_PARSER.make_regexp, '') # remove url
    Rails.logger.info { "Analyzing sentiment of Comment #{comment.floor} of Post #{comment.post_dcard_id}" }
    Baidu::Aip.new.sentiment(text)
  end
end
