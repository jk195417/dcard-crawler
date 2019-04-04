class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :auth_admin

  private

  # admin is first user, user.id == 1
  def auth_admin
    return if current_user.id == 1

    redirect_to root_path, alert: 'You are not admin!'
  end
end
