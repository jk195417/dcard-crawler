class Dcard::PostCrawler < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find post_id

    # update post
    post.pull_from_dcard
    post.save!
    Rails.logger.info "Post #{post.dcard_id} content updated."

    # get new comments
    import_comments = []
    latest_floor = post.comments.order(floor: :desc).first&.floor # return latest_floor or nil
    loop do
      new_comments = post.new_comments_from_dcard(after: latest_floor)
      break if new_comments.blank?

      import_comments += new_comments
      latest_floor = new_comments.max { |a, b| a[:floor].to_i <=> b[:floor].to_i }[:floor]
    end
    import_comments_count = import_comments.size
    return if import_comments_count <= 0

    Post.transaction do
      Comment.import import_comments
      Post.update_counters(post.id, comments_count: import_comments_count)
    end
    Rails.logger.info "Post #{post.dcard_id} get #{import_comments_count} new comments and inserted into database."
  end
end
