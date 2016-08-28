class Event::SessionsController < ApplicationController
  before_action :set_event

  # INDEX /events/1/sessions
  def index
    render json: {
      sessions: @event.sessions.map do |session|
        {
          id: session.id,
          title: session.title,
          description: session.description,
          level: session.level,
          starts_at: session.starts_at.utc.iso8601,
          ends_at: session.ends_at.utc.iso8601,
          cost: {
            fractional: session.ticket_cost,
            currency: session.ticket_currency
          }
        }
      end
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:event_id])
    end
end
