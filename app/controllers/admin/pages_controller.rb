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
    @res = JSON.parse(HTTP.get(Dcard::Api.search_posts(query, forum: forum).to_s))
    if @res.class == Hash && @res[:error].present?
      flash[:notice] = 'Something wrong when searching on Dcard.'
    else
      @posts = @res.map { |data| Post.new.load_from_dcard data }
      @exist_posts = Post.where(dcard_id: @posts.map(&:dcard_id))
      flash[:notice] = "We found #{@posts.size} Posts about #{query} on Dcard."
    end
  end
end
