module App::Actions
  extend self
  def get_posts(recent: false, popular: false)
    Forum.where(is_school: false).find_each do |forum|
      PostsCrawler.perform_async(forum.id, recent, popular)
    end
  end
end
