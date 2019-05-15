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
    @alert = { notice: "Crawling posts of forum #{@forum.id}, you can refresh your browser to read it." }
    respond_to do |format|
      format.html { redirect_back({ fallback_location: admin_posts_path }.merge(@alert)) }
      format.js
    end
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
