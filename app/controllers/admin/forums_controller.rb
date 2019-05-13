class Admin::ForumsController < Admin::BaseController
  before_action :set_forum, only: %i[show update destroy]

  def index
    @q = Forum.ransack(params[:q])
    @forums = @q.result(distinct: true).page(params[:page])
  end

  def show; end

  def create
    Dcard::UpdateForumsJob.perform_later
    redirect_back fallback_location: admin_forums_path, notice: 'Crawling every forums, you can refresh your browser to read it.'
  end

  def update
    Dcard::GetForumPostsJob.perform_later(@forum.id)
    redirect_back fallback_location: admin_forums_path, notice: "Crawling posts of forum #{@forum.id}, you can refresh your browser to read it."
  end

  def batch_update
    forum_ids = params[:ids]
    forum_ids.each do |id|
      Dcard::GetForumPostsJob.perform_later(id)
    end
    redirect_back fallback_location: admin_posts_path, notice: "Crawling posts of forums #{forum_ids}, you can refresh your browser to read it."
  end

  def destroy
    @forum.destroy
    redirect_to admin_forums_url, notice: "Forum #{@forum.name} was successfully destroyed."
  end

  private

  def set_forum
    @forum = Forum.find(params[:id])
  end
end
