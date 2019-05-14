# Usage :
# Dcard::GetForumPostsJob.perform_now(forum.id)
# Dcard::GetForumPostsJob.perform_now(forum.id, true)

class Dcard::GetForumPostsJob < ApplicationJob
  queue_as :default

  def perform(id, recent = false)
    forum = ::Forum.find id
    posts_json = if recent
                   newest = forum.posts.select(:dcard_id).order(dcard_id: :desc).first
                   Dcard::Post.get(forum: forum.alias, after: newest&.dcard_id)
                 else
                   oldest = forum.posts.select(:dcard_id).order(dcard_id: :asc).first
                   Dcard::Post.get(forum: forum.alias, before: oldest&.dcard_id)
                 end
    Rails.logger.info "Can\'t find new posts at Forum #{forum.alias}." and return if posts_json.empty?

    posts = Dcard::Post.to_records(posts_json)
    posts_count = 0
    posts.each do |post|
      post.forum = forum
      posts_count += 1
    end
    ::Forum.transaction do
      result = ::Post.import(posts)
      posts_count = result.ids.size
      ::Forum.update_counters(forum.id, posts_count: posts_count)
    end
    Rails.logger.info "Forum #{forum.alias} get #{posts_count} new posts."
  end
end
