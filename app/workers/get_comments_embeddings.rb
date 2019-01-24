class GetCommentsEmbeddings
  include Sidekiq::Worker

  def perform(first_comment_id, last_comment_id)
    comments = Comment.select(:id, :content).where(id: (first_comment_id..last_comment_id), embedding: nil).where.not(content: [nil, ''])
    comments_content = comments.map(&:content)
    return if comments.blank?

    # get comments embeddings
    response = $bc.encode(comments_content)
    comments.each.with_index do |comment, i|
      comment.embedding = PyCall::List.call(response[i]).to_a
    end

    # bulk update comments at one sql, like a upsert.
    Comment.import comments.as_json, on_duplicate_key_update: [:embedding]
    App.logger.info "Update comments embeddings between #{first_comment_id} and #{last_comment_id}."
  end
end
