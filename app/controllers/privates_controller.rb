class PrivatesController < ApplicationController
  before_action :set_private, only: [:show]

  # GET /privates/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_private
      @private = Private.find(params[:id])
      @event = @private.event
    end
end
