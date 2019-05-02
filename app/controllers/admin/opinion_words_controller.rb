class Admin::OpinionWordsController < Admin::BaseController
  before_action :set_opinion_word, only: [:destroy]

  def index
    @q = OpinionWord.ransack(params[:q])
    @opinion_words = @q.result(distinct: true).order(:id).page(params[:page])
  end

  def destroy
    @opinion_word.destroy
    redirect_to admin_opinion_words_url, notice: "Opinion word #{@opinion_word.id} was successfully destroyed."
  end

  private

  def set_opinion_word
    @opinion_word = OpinionWord.find(params[:id])
  end
end
