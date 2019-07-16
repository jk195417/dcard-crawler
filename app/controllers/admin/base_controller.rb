class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :auth_admin

  private

  def auth_admin
    return if current_user.is_admin?

    redirect_to root_path, alert: 'You are not admin!'
  end
end
