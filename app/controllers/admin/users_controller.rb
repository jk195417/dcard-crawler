class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:destroy]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page])
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: "User #{@user.email} was successfully destroyed."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
