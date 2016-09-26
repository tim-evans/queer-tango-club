class UsersController < ApplicationController
  before_action :set_user, only: [:show]
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by_id(params[:id])
      raise ActiveRecord::RecordNotFound.new if @user.nil?
    end
end
