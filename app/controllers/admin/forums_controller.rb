class Admin::ForumsController < Admin::BaseController
  before_action :set_forum, only: %i[show update destroy]

  def index
    forums = Forum.all
    forums = forums.where(is_school: false) if params[:is_school] == 'false'
    @forums = forums.order(id: :asc).page(params[:page])
  end

  def show; end

  def create
    GetForumsJob.perform_later
    redirect_back fallback_location: admin_forums_path, notice: 'Crawling every forums, you can refresh your browser to read it.'
  end

  def update
    Dcard::ForumCrawler.perform_later(@forum.id)
    redirect_back fallback_location: admin_forums_path, notice: "Crawling posts of forum #{@forum.id}, you can refresh your browser to read it."
  end

  def batch_update
    forum_ids = params[:ids]
    forum_ids.each do |id|
      Dcard::ForumCrawler.perform_later(id)
    end
    redirect_back fallback_location: admin_posts_path, notice: "Crawling posts of forums #{forum_ids}, you can refresh your browser to read it."
  end

  def destroy
    @forum.destroy
    redirect_to admin_posts_url, notice: "Forum #{@forum.name} was successfully destroyed."
  end

  private

  def set_forum
    @forum = Forum.find(params[:id])
  end
end
