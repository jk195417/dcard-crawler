class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: %i[show update destroy]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).page(params[:page])
  end

  def show; end

  def update
    Dcard::PostCrawler.perform_later(@post.id)
    redirect_back fallback_location: admin_posts_path, notice: "Crawling comments of post #{@post.id}, you can refresh your browser to read it."
  end

  def batch_update
    post_ids = params[:ids]
    post_ids.each do |id|
      Dcard::PostCrawler.perform_later(id)
    end
    redirect_back fallback_location: admin_posts_path, notice: "Crawling comments of posts #{post_ids}, you can refresh your browser to read it."
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end
