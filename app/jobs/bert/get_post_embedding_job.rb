# Usage :
# Bert::GetPostEmbeddingJob.perform_later(post)

class Bert::GetPostEmbeddingJob < ApplicationJob
  queue_as :default
  def perform(post)
    bc = Bert::Service.new
    sentences = [content_filter(post.content)]
    comment_ids = []
    post.comments.select(:id, :content).find_each do |comment|
      begin
        sentences << content_filter(comment.content)
        comment_ids << comment.id
      rescue StandardError => e
        Rails.logger.error { e }
      end
    end
    embeddings = bc.perform(post.id, sentences)
    post_embedding = embeddings.shift
    new_comments = embeddings.map.with_index { |embedding, index| { id: comment_ids[index], embedding: embedding } }
    Post.transaction do
      post.update!(embedding: post_embedding)
      Comment.import(new_comments, validate: false, on_duplicate_key_update: { conflict_target: [:id], columns: [:embedding] })
    end
  end

  private

  def content_filter(text)
    raise "Can't encode \"\" or nil." if text.blank?

    result = text.gsub(URI::DEFAULT_PARSER.make_regexp, '').gsub(/[bB]\d+/, '').gsub(/\s*\n+\s*/, ' ||| ').gsub(/(\A\s\|\|\|\s|\s\|\|\|\s\z)/, '')
    raise 'After encode, result become "" or nil.' if result.blank?

    result
  end
end
