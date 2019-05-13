class Admin::PagesController < Admin::BaseController
  def statistics
    @forums_count = Forum.count
    @posts_count = Post.count
    @comments_count = Comment.count
    @reviews_count = Review.count
    @users_count = User.count
    @opinion_words_count = OpinionWord.count
  end

  def explore
    @posts = []
    @exist_posts = []
    return if params[:query].blank?

    query = params[:query]
    forum = params[:forum]
    posts_json = Dcard::Post.search(query: query, forum: forum)
    if posts_json.class == Hash && posts_json[:error].present?
      flash[:notice] = 'Something wrong when searching on Dcard.'
    else
      @posts = Dcard::Post.to_records(posts_json)
      @exist_posts = Post.where(dcard_id: @posts.map(&:dcard_id))
      flash[:notice] = "We found #{@posts.size} Posts about #{query} on Dcard."
    end
  end
end
