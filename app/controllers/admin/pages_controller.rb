class Admin::PagesController < Admin::BaseController
  def statistics
    @forums_count = Forum.count
    @posts_count = Post.count
    @comments_count = Comment.count
    @reviews_count = Review.count
    @users_count = User.count
  end
end
