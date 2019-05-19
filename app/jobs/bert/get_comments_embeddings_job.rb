# Usage :
# Bert::GetCommentsEmbeddingsJob.perform_later(comments.map(&:id))

class Bert::GetCommentsEmbeddingsJob < ApplicationJob
  queue_as :default
  
  include CommentHelper

  def perform(ids)
    comments = Comment.where(id: ids)
    bc = Bert::Service.new
    comment_ids = []
    sentences = []
    comments.each do |comment|
      begin
        sentences << bert_multi_sentences_encoder(comment.content)
        comment_ids << comment.id
      rescue StandardError => e
        Rails.logger.error { e }
      end
    end
    Rails.logger.info { 'No comments need to get embedding.' } && return if sentences.empty?

    embeddings = bc.perform(ids[0], sentences)
    new_comments = embeddings.map.with_index { |embedding, index| { id: comment_ids[index], embedding: embedding } }
    result = Comment.import(new_comments, validate: false, on_duplicate_key_update: { conflict_target: [:id], columns: [:embedding] })
    Rails.logger.info { "Comments #{result.ids} embeddings updated." }
    new_comments
  end
end
