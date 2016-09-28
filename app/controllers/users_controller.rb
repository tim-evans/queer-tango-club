class UsersController < ApplicationController
  before_action :set_user, only: [:show, :logout]
  before_filter :authorize

  def authorize
    if current_user
      true
    else
      render file: "#{Rails.root}/app/views/errors/not_found.html" , status: :not_found
    end
  end

  def index
    @users = User.all.order(name: :desc)
  end

  def show
  end

  def new
    @user = User.new
  end

  def logout
    @user.user_sessions.destroy_all
    if @user == current_user
      redirect_to sign_in_path, flash: { notice: "Signed out successfully." }
    else
      redirect_to users_path, flash: { notice: "Signed out #{@user.name || @user.email}." }
    end
  end

  def create
    user = User.new(user_params.merge(password: Devise.friendly_token[0,20]))
    if user.save
      redirect_to user_path(user), flash: { notice: "#{user.email} has access!" }
    else
      redirect_to new_user_path, flash: { error: user.errors.full_messages }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by_id(params[:id])
      raise ActiveRecord::RecordNotFound.new if @user.nil?
    end

    def user_params
      params.require(:user).permit(:email)
    end
end
