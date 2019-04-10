class Admin::ReviewsController < Admin::BaseController
  before_action :set_review, only: [:destroy]

  def index
    @q = Review.ransack(params[:q])
    @reviews = @q.result(distinct: true).includes(:post, :user).page(params[:page])
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
