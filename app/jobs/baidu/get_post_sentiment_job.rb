# Usage :
# Baidu::GetPostSentimentJob.perform_now(Post.random.first.id)

class Baidu::GetPostSentimentJob < ApplicationJob
  def perform(id)
    post = Post.find id
    text = post.content&.gsub(URI::DEFAULT_PARSER.make_regexp, '') # remove url
    Rails.logger.info { "Analyzing sentiment of Post #{post.dcard_id}" }
    result = Baidu::Aip.new.sentiment(text)
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
    Rails.logger.info { "Sentiment of Post #{post.dcard_id} is analyzed" }
    post.comments.find_each do |comment|
      Baidu::GetCommentSentimentJob.perform_later(comment.id)
    end
    sleep(1)
    Rails.logger.info { "Scheduling analyze sentiment of comments, which belongs to post #{post.dcard_id} " }
  end
end
