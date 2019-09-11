class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[edit update destroy]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page])
  end

  def update
    @alert = {}
    old_status = @user.is_scholar
    new_status = !old_status
    @user.is_scholar = new_status
    if @user.save
      @alert[:notice] = "User #{@user.email} has been updated, is_scholar = #{new_status}"
    else
      @alert[:alert] = "Fail to update user #{@user.email}, is_scholar = #{old_status}"
    end
    respond_to do |format|
      format.html { redirect_back({ fallback_location: admin_users_path }.merge(@alert)) }
      format.js
    end
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
