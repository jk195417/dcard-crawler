# Usage :
# Baidu::GetSentimentJob.perform_now(post_or_comment)

class Baidu::GetSentimentJob < ApplicationJob
  queue_as :baidu

  def perform(post_or_comment)
    text = post_or_comment.content&.gsub(URI::DEFAULT_PARSER.make_regexp, '') # remove url
    result = Baidu::Aip.new.sentiment(text)
    Rails.logger.error { "Can\'t get sentiment of #{post_or_comment}" } && return if result.blank?

    Sentiment.find_or_create_by(sentimental: post_or_comment) do |sentiment|
      sentiment.positive = result['positive_prob']
      sentiment.negative = result['negative_prob']
      sentiment.confidence = result['confidence']
      sentiment.sentiment = result['sentiment']
    end
    sleep(1)
  end
end
