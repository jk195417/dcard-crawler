# Usage :
# Baidu::GetSentimentJob.perform_now(post_or_comment)

class Baidu::GetSentimentJob < ApplicationJob
  queue_as :baidu

  def perform(post_or_comment)
    text = content_filter(post_or_comment.content)
    sentiment = Sentiment.find_or_initialize_by(sentimental: post_or_comment)
    result = Baidu::Aip.new.sentiment(text)
    Rails.logger.error { "Can\'t get sentiment of #{post_or_comment}" } && return if result.blank?

    sentiment.positive = result['positive_prob']
    sentiment.negative = result['negative_prob']
    sentiment.confidence = result['confidence']
    sentiment.sentiment = result['sentiment']
    sentiment.save!
    sleep(1)
  end

  private

  def content_filter(content)
    raise 'no content' if content.blank?
    content = content.gsub(URI::DEFAULT_PARSER.make_regexp, '') # remove url
    content = content.gsub(/[bB]\d+/, '')  # remove mentions
  end
end
