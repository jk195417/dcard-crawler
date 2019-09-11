class Scholar::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :auth_scholar

  private

  def auth_scholar
    return if current_user.is_scholar

    redirect_to root_path, alert: 'You are not scholar.'
  end
end
