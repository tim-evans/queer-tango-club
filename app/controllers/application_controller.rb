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
    user = UserSession.find_by_session_id(access_token).try(:user)
    user_group = user.try(:group)
    @current_user = user if user_group == group
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
