class GetPostsJob < ApplicationJob
  queue_as :default

  def perform(recent = false, popular = false)
    Forum.where(is_school: false).find_each do |forum|
      Dcard::ForumCrawler.perform_later(forum.id, recent, popular)
    end
  end
end
