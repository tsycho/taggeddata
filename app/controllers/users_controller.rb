class UsersController < ApplicationController
  before_action :require_login

  def show
    @user = current_user
  end

  def create_api_key
    current_user.api_keys.create(:key => SecureRandom.hex(16))
    redirect_to user_path
  end

  def delete_api_key
    api_key = ApiKey.where(:key => params[:key]).first
    api_key.destroy if api_key
    redirect_to user_path
  end
end
