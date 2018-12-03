module App::Actions
  def get_posts_comments(console: false)
    Post.where('comments_count < comment_count').find_each do |post|
      App.workers.add_task do
        begin
          import_comments = []
          latest_floor = post.comments.order(floor: :desc).first&.floor
          loop do
            new_comments = post.new_comments_from_dcard(after: latest_floor)
            break unless new_comments.is_a?(Array)
            break if new_comments.empty?
            import_comments += new_comments
            latest_floor = new_comments.max { |a, b| a[:floor].to_i <=> b[:floor].to_i }[:floor]
          end
          results = Comment.import import_comments
          results_count = results.ids.size
          if results_count > 0
            Post.update_counters(post.id, comments_count: results_count)
            App.logger.info "Post #{post.dcard_id} get #{results_count} new comments and inserted into database"
          end
        rescue => e
          App.logger.error e.inspect
        end
      end
      App.workers.work
    end
  end
end
