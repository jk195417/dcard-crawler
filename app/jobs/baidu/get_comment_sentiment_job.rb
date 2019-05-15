# Usage :
# Baidu::GetCommentSentimentJob.perform_now(comment.id)

class Baidu::GetCommentSentimentJob < ApplicationJob
  def perform(id)
    comment = Comment.find id
    Rails.logger.info { "Analyzing sentiment of Comment #{comment.floor} of Post #{comment.post_dcard_id}" }
    text = comment.content&.gsub(URI::DEFAULT_PARSER.make_regexp, '') # remove url
    result = Baidu::Aip.new.sentiment(text)
    Rails.logger.info { "Can\'t get sentiment of Comment #{comment.floor} of Post #{comment.post_dcard_id}" } && return if result.blank?

    if comment.sentiment.present?
      comment.sentiment.positive = result['positive_prob']
      comment.sentiment.negative = result['negative_prob']
      comment.sentiment.confidence = result['confidence']
      comment.sentiment.sentiment = result['sentiment']
    else
      comment.create_sentiment!(positive: result['positive_prob'],
                              negative: result['negative_prob'],
                              confidence: result['confidence'],
                              sentiment: result['sentiment'])
    end
    comment.save!
    sleep(1)
    Rails.logger.info { "Sentiment of Comment #{comment.floor} of Post #{comment.post_dcard_id} is analyzed" }
  end
end
