class PostsCrawler
  include Sidekiq::Worker

  def perform(forum_id, recent=false, popular=false)
    new_posts = []
    forum = Forum.find forum_id
    new_posts += forum.new_posts_from_dcard(recent: recent, popular: popular)
    new_posts_count = new_posts.size
    return unless new_posts_count > 0
    Forum.transaction do
      Post.import new_posts
      Forum.update_counters(forum_id, posts_count: new_posts_count)
    end
    App.logger.info "Forum #{forum_id} get #{new_posts_count} new posts and inserted into database"
  end
end
