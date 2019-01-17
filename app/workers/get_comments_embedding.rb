class GetCommentsEmbedding
  include Sidekiq::Worker
  pyfrom 'bert_serving.client', import: :BertClient
  def perform(post_id)
    post = Post.find post_id
    # TODO: comments need pagination or it will be too large to process
    comments = post.comments
    comments_content.map { |c| c.content }
    comments_size = comments.size
    bert_client = BertClient.new
    response = bert_client.encode(comments_content)
    0.upto(comments_size - 1) do |i|
     comments[i].embedding = PyCall::List.(response[i]).to_a
    end
    Comment.import comments, on_duplicate_key_update: [:embedding]
  end
end
