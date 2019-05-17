# Usage :
# Bert::GetPostEmbeddingJob.perform_later(post.id)

class Bert::GetPostEmbeddingJob < ApplicationJob
  include CommentHelper

  def perform(id)
    post = Post.find id
    bc = Bert::Service.new

    # post
    sentences = [bert_multi_sentences_encoder(post.content)]
    embeddings = bc.perform(id, sentences)
    post.update!(embedding: embeddings[0])
    Rails.logger.info { "Post #{id} embedding updated." }

    # post.comments
    Bert::GetCommentsEmbeddingsJob.perform_later(post.comments.ids)
    Rails.logger.info { "Bert::GetCommentsEmbeddingsJob for comments of post #{id} is scheduled." }
  end
end
