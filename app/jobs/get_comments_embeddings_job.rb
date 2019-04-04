class GetCommentsEmbeddingsJob < ApplicationJob
  queue_as :default

  def perform
    # batch update comment's embedding, each time update 256 comments.
    batch_size = 256
    Comment.select(:id).where(embedding: nil).where.not(content: [nil, '']).find_in_batches(batch_size: batch_size) do |comments|
      Bert::GetCommentsEmbeddings.perform_later(comments.first.id, comments.last.id)
    end
  end
end
