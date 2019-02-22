module App::Actions
  extend self
  def get_comments_embeddings
    # batch update comment's embedding, each time update 256 comments.
    batch_size = 256
    Comment.select(:id).where(embedding: nil).where.not(content: [nil, '']).find_in_batches(batch_size: batch_size) do |comments|
      GetCommentsEmbeddings.perform_async(comments.first.id, comments.last.id)
    end
  end
end
