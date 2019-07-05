class Admin::PagesController < Admin::BaseController
  def statistics
    @forums_count = Forum.count
    @posts_count = Post.count
    @comments_count = Comment.count
    @reviews_count = Review.count
    @users_count = User.count
    @sentiments_count = Sentiment.count
  end

  def explore
    @posts = []
    @exist_posts = []
    query = params[:query]
    forum = params[:forum]
    posts_json = if query.blank?
                   Dcard::Post.get(popular: true, forum: forum)
                 else
                   Dcard::Post.search(query: query, forum: forum)
                 end
    if posts_json.class == Hash && posts_json[:error].present?
      flash[:notice] = 'Something wrong when searching on Dcard.'
    else
      @posts = Dcard::Post.to_records(posts_json)
      @exist_posts = Post.where(dcard_id: @posts.map(&:dcard_id))
      flash[:notice] = "We found #{@posts.size} Posts about #{query} on Dcard."
    end
  end
end
