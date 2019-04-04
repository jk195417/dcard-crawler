class Admin::ReviewsController < Admin::BaseController
  before_action :set_review, only: [:destroy]

  def index
    reviews = if params[:post_id]
                Review.where(post_id: params[:post_id])
              else
                Review.all
              end
    reviews = if params[:user_id]
                reviews.where(user_id: params[:user_id])
              else
                reviews
              end
    @reviews = reviews.includes(:post, :user).page(params[:page]).per(10)
  end

  def destroy
    @review.destroy
    redirect_to admin_reviews_url, notice: "Review #{@review.id} was successfully destroyed."
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end
end
