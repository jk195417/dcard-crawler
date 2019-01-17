class GetPostsEmbedding
  include Sidekiq::Worker
  def perform(forum_id)
    forum = Forum.find forum_id
    # TODO: Get Posts Embedding
  end
end
