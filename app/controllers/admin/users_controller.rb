class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:destroy]

  def index
    @users = User.page(params[:page]).per(10)
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
