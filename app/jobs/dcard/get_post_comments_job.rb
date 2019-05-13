class Dcard::GetPostCommentsJob < ApplicationJob
  queue_as :default

  def perform(id)
    post = ::Post.find id
    comments = []
    latest_comment = post.comments.select(:floor).order(floor: :desc).first
    loop do
      comments_json = Dcard::Comment.get(post.dcard_id, after: latest_comment&.floor)
      break if comments_json.empty?

      new_comments = Dcard::Comment.to_records(comments_json)
      comments += new_comments
      latest_comment = new_comments.last
    end
    Rails.logger.info "Can\'t find new comments at Post #{post.dcard_id}." and return if comments.empty?

    comments_count = 0
    comments.each do |comment|
      comment.post = post
      comments_count += 1
    end
    ::Post.transaction do
      result = ::Comment.import comments
      comments_count = result.ids.size
      ::Post.update_counters(post.id, comments_count: comments_count)
    end
    Rails.logger.info "Post #{post.dcard_id} get #{comments_count} new comments."
  end
end
