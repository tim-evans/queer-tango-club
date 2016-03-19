class Event::MembersController < ApplicationController
  before_action :set_event

  def index
    @smart_collapse = @event.highlight? && @event.sessions.any?(&:highlight?)
    redirect_to(event_path(@event)) unless current_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.where(id: params[:event_id]).includes({ sessions: [{ attendees: :member }] }).first
    end
end
