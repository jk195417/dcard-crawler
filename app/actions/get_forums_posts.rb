module App::Actions
  def get_forums_posts(recent: false, popular: false)
    new_posts = []
    Forum.find_each do |forum|
      App.workers.add_task do
        new_posts += forum.new_posts_from_dcard(recent: recent, popular: popular)
      end
    end
    App.workers.work
    result = Post.import(new_posts)
    Forum.find_each do |forum|
      App.workers.add_task do
        Forum.reset_counters(forum.id, :posts)
      end
    end
    App.workers.work
    App.logger.info "Get #{result.ids.size} new posts and inserted into database"
  end
end
