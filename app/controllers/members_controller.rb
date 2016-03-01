class MembersController < ApplicationController
  before_action :set_event

  def index
    redirect_to(event_path(@event)) unless current_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:event_id])
    end
end
