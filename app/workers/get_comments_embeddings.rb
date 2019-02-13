class GetCommentsEmbeddings
  include Sidekiq::Worker

  def perform(first_comment_id, last_comment_id)
    comments = Comment.where(id: (first_comment_id..last_comment_id), embedding: nil).where.not(content: [nil, '']).pluck(:id, :content)
    return if comments.blank?

    comment_ids = []
    comment_contents = []
    comments.each do |comment|
      comment_ids << comment[0]
      comment_contents << comment[1]
    end 

    # get comments embeddings
    bc = BertClient.new
    comment_embeddings = bc.encode(comment_contents)
    bc.close

    data = []
    comment_ids.each.with_index do |id, index|
      embedding = PyCall::List.call(comment_embeddings[index]).to_a
      data << { id: id, embedding: embedding }
    end

    # bulk update comments at one sql, like a upsert.
    Comment.import data, on_duplicate_key_update: [:embedding]
    App.logger.info "Update comments embeddings between #{first_comment_id} and #{last_comment_id}."
  end
end
