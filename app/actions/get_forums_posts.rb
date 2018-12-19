module App::Actions
  extend self
  def get_forums_posts(recent: false, popular: false)
    Forum.find_each do |forum|
      PostsCrawler.perform_async(forum.id, recent, popular)
    end
  end
end
