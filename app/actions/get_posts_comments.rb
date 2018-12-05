module App::Actions
  def get_posts_comments
    Post.not_removed.where('comment_count > 0').where(comments_count: 0).find_each do |post|
      App.workers.add_task do
        begin
          import_comments = []
          latest_floor = post.comments.order(floor: :desc).first&.floor

          loop do
            new_comments = post.new_comments_from_dcard(after: latest_floor)
            break if new_comments.blank?
            import_comments += new_comments
            latest_floor = new_comments.max { |a, b| a[:floor].to_i <=> b[:floor].to_i }[:floor]
          end

          import_comments_size = import_comments.size
          if import_comments_size > 0
            Post.transaction do
              Comment.import import_comments
              Post.update_counters(post.id, comments_count: import_comments_size)
            end
            App.logger.info "Post #{post.dcard_id} get #{import_comments_size} new comments and inserted into database"
          end
        rescue => e
          App.logger.error e.inspect
        end
      end
      App.workers.work
    end
  end
end
