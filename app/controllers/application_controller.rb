class ApplicationController < ActionController::Base
  include JSONAPI::ActsAsResourceController

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_filter :current_user

  def context
    {
      current_user: current_user,
      group: group
    }
  end

  def current_user
    return @current_user if @current_user && access_token
    user_id = UserSession.find_by_session_id(access_token).try(:user_id)
    @current_user = group.users.find(user_id) if user_id
  end

  def group
    Group.find_by_api_key(api_key)
  end

  def api_key
    request.headers['ApiKey'] || request.headers['Api-Key']
  end

  def access_token
    request.headers['AccessToken'] || request.headers['Access-Token']
  end

  def authorize
    if current_user
      true
    else
      head :unauthorized
    end
  end

  def not_found
    head :not_found
  end

  def internal_server_error
    head :internal_server_error
  end
end
