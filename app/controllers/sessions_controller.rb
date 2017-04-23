class SessionsController < ApplicationController
  prepend_before_filter :set_default_includes

  def set_default_includes
    unless params[:include]
      params[:include] = 'location,guests'
    end
  end
end
