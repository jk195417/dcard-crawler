# frozen_string_literal: true

class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: %i[show update export destroy]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).order(id: :desc).page(params[:page])
  end

  def show
    @comments = @post.comments.order(floor: :asc).page(params[:page])
  end

  def create
    forum = Forum.find_by!(name: post_params[:forum_name])
    @post = Post.new(post_params)
    @post.forum = forum
    respond_to do |format|
      if @post.save
        Dcard::PostCrawler.perform_later(@post.id)
        @alert = { type: 'notice', message: "Crawling comments of post #{@post.id}, you can refresh your browser to read it." }
        format.html { redirect_back fallback_location: admin_posts_path, notice: @alert[:message] }
      else
        @alert = { type: 'alert', message: "Can not crawl this post from #{@post.dcard_url}, maybe you already crawled it." }
        format.html { redirect_back fallback_location: admin_posts_path, alert: @alert[:message] }
      end
      format.js
    end
  end

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

  def export
    text = [@post.content]
    @post.comments.order(floor: :asc).each do |comment|
      text << comment.content if comment.content.present?
    end
    method = params.fetch(:method, 'jieba')
    @segmentation = Segmentation::Service.new.perform(text, method)
    respond_to do |format|
      format.text { response.headers['Content-Disposition'] = "attachment; filename=\"dcard-#{@post.dcard_id}-#{method}-segmentation.txt\"" }
      format.xlsx { render xlsx: 'export', filename: "dcard-#{@post.dcard_id}-#{method}-segmentation.xlsx" }
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:dcard_id, :forum_name)
  end
end
