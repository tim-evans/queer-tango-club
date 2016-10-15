class Event::AttendeesController < ApplicationController
  before_action :set_event
  before_filter :authorize

  def index
  end

  def new
    @attendee = Attendee.new
    @attendee.member = Member.new
  end

  def create
    member = create_or_find_member!
    attendees = sessions.map do |session|
      session.attendees.create(member: member,
                               amount_paid: attendee_params[:amount_paid],
                               payment_method: attendee_params[:payment_method])
    end

    if attendees
      redirect_to event_attendees_path(@event)
    else
      redirect_to new_event_attendee_path(@event), flash: { error: @attendees.map(&:errors).map(&:full_messages) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.where(id: params[:event_id]).includes({ sessions: [{ attendees: :member }] }).first
    end

    def sessions
      @event.sessions.find(params[:attendee][:sessions].keys)
    end

    def create_or_find_member!
      if attendee_params[:email].present?
        member = Member.find_by_email(attendee_params[:email])
        return member if member
      end

      if attendee_params[:name].present?
        by_name = Member.where('lower(name) = ?', attendee_params[:name].downcase)
        if by_name.count == 1
          return by_name[0]
        end
      end

      Member.create(attendee_params.permit(:name, :email))
    end

    def attendee_params
      params.require(:attendee).permit(:name, :email, :display_amount_paid).tap do |attrs|
        attrs[:email] = nil if attrs[:email].blank?

        Monetize.assume_from_symbol = true
        amount = Monetize.parse(attrs[:display_amount_paid])
        attrs.delete(:display_amount_paid)

        attrs[:amount_paid] = amount / sessions.size
        if amount.zero?
          attrs[:payment_method] = :gratis
        else
          attrs[:payment_method] = :cash
        end
      end
    end
end
