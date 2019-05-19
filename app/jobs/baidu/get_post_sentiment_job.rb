# Usage :
# Baidu::GetPostSentimentJob.perform_now(Post.random.first.id)

class Baidu::GetPostSentimentJob < ApplicationJob
  queue_as :baidu
  
  def perform(id)
    post = Post.find id

    # comments
    Rails.logger.info { "Scheduling analyze sentiment of comments, which belongs to post #{post.dcard_id}" }
    post.comments.find_each do |comment|
      Baidu::GetCommentSentimentJob.perform_later(comment.id)
    end

    # post
    Rails.logger.info { "Analyzing sentiment of Post #{post.dcard_id}" }
    text = post.content&.gsub(URI::DEFAULT_PARSER.make_regexp, '') # remove url
    result = Baidu::Aip.new.sentiment(text)
    Rails.logger.info { "Can\'t get sentiment of Post #{post.dcard_id}" } && return if result.blank?

    if post.sentiment.present?
      post.sentiment.positive = result['positive_prob']
      post.sentiment.negative = result['negative_prob']
      post.sentiment.confidence = result['confidence']
      post.sentiment.sentiment = result['sentiment']
    else
      post.build_sentiment(positive: result['positive_prob'],
                           negative: result['negative_prob'],
                           confidence: result['confidence'],
                           sentiment: result['sentiment'])
    end
    post.save!
    sleep(1)
    Rails.logger.info { "Sentiment of Post #{post.dcard_id} is analyzed" }
  end
end
