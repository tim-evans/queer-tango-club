class PrivatesController < ApplicationController
  before_action :set_private, only: [:show, :inquire]

  # GET /events/1/privates/1
  def show
  end

  # POST /events/1/privates/1/inquire
  def inquire
    # Send email about inquiry
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_private
      @event = Event.find(params[:event_id])
      @private = @event.privates.find(params[:id])
    end
end
