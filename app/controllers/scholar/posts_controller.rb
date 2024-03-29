class Scholar::PostsController < Scholar::BaseController
  before_action :set_post, except: %i[index create]
  before_action :set_comments, only: %i[show visualization]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).order(id: :desc).page(params[:page])
  end

  def show
    @comments = @comments.page(params[:page])
  end

  def create
    forum = Forum.find_by!(name: post_params[:forum_name])
    @post = Post.new(post_params)
    @post.forum = forum
    @alert = {}
    if @post.save
      Dcard::UpdatePostJob.perform_later(@post)
      @alert[:notice] = "Crawling comments of Post #{@post.dcard_id}, you can refresh your browser to read it."
    else
      @alert[:alert] = "Can not crawl this Post from #{@post.dcard_url}, maybe you already crawled it."
    end
    respond_to do |format|
      format.html { redirect_back({ fallback_location: scholar_posts_path }.merge(@alert)) }
      format.js
    end
  end

  def update
    Dcard::UpdatePostJob.perform_later(@post)
    @alert = { notice: "Crawling comments of Post #{@post.dcard_id}, you can refresh your browser to read it." }
    respond_to do |format|
      format.html { redirect_back({ fallback_location: scholar_posts_path }.merge(@alert)) }
      format.js
    end
  end

  def destroy
    @post.destroy
    redirect_to scholar_posts_url, notice: 'Post was successfully destroyed.'
  end

  def clusters
    @kmeans = OpinionsClusterJob.perform_now @post, params.fetch(:k) { 1 }
    @clusters = @kmeans.clusters.map { |cluster| @post.comments.where(floor: cluster.points.map(&:label)).includes(:sentiment).order(floor: :asc) }
  end

  def visualization
    begin
      if params[:k]
        @kmeans = OpinionsClusterJob.perform_now @post, params[:k]
        @clusters = @kmeans&.clusters&.map { |cluster| cluster.points.map(&:label) }
      else
        k = BestOpinionsClusterJob.perform_now(@post).k
        redirect_to visualization_scholar_post_path(@post, k: k)
      end
    rescue StandardError => e
      flash[:alert] = e
      @kmeans = nil
    end

    text = [content_filter(@post.content)]
    @comments.each do |comment|
      text << content_filter(comment.content) if comment.content.present?
    end
    @segmentation = Segmentation::Service.new.perform(text, 'jieba')
  end

  def segment
    text = [@post.content]
    @post.comments.order(floor: :asc).each do |comment|
      text << comment.content if comment.content.present?
    end
    method = params.fetch(:method, 'jieba')
    @segmentation = Segmentation::Service.new.perform(text, method)
    respond_to do |format|
      format.text { response.headers['Content-Disposition'] = "attachment; filename=\"dcard-#{@post.dcard_id}-#{method}.txt\"" }
      format.xlsx { render xlsx: 'segment', filename: "dcard-#{@post.dcard_id}-#{method}.xlsx" }
    end
  end

  def sentiment_analysis
    Baidu::GetPostSentimentJob.perform_later(@post)
    @alert = { notice: "Scheduling sentiment analysis of Post #{@post.dcard_id} and its comments." }
    respond_to do |format|
      format.html { redirect_back({ fallback_location: scholar_posts_path }.merge(@alert)) }
      format.js
    end
  end

  def compute_embedding
    Bert::GetPostEmbeddingJob.perform_later(@post)
    @alert = { notice: "Scheduling compute embedding of Post #{@post.dcard_id} and its comments." }
    respond_to do |format|
      format.html { redirect_back({ fallback_location: scholar_posts_path }.merge(@alert)) }
      format.js
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def set_comments
    @comments = @post.comments.includes(:sentiment).order(floor: :asc)
  end

  def post_params
    params.require(:post).permit(:dcard_id, :forum_name)
  end

  def content_filter(content)
    return '' if content.blank?
    content = content.gsub(URI::DEFAULT_PARSER.make_regexp, '') # remove url
    content = content.gsub(/[bB]\d+/, '')  # remove mentions
  end
end
