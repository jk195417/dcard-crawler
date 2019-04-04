class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: %i[edit update destroy]

  def index
    @reviews = current_user.reviews.includes(:post).order(id: :desc).page(params[:page]).per(10)
  end

  def new
    reviewd_post_ids = current_user.reviews.pluck(:post_id)
    # posts = Post.reviewable.where.not(id: reviewd_post_ids)
    # random_offset = rand(posts.count)
    # @post = posts.offset(random_offset).first
    @post = Post.reviewable.where.not(id: reviewd_post_ids).order(reviews_count: :desc).first
    @review = current_user.reviews.build(post: @post)
  end

  def edit; end

  def create
    @review = Review.new(review_params)
    @post = @review.post
    if @review.save
      redirect_to new_review_path, notice: "Post : [#{@review.post.title}] reviewed."
    else
      render :new
    end
  end

  def update
    if @review.update(review_params)
      redirect_to reviews_path, notice: "Post : [#{@review.post.title}] reviewed."
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to reviews_path, notice: 'Review was successfully destroyed.'
  end

  private

  def set_review
    @review = current_user.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:user_id, :post_id, :echo_chamber)
  end
end