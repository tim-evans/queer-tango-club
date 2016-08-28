class Event::DiscountsController < ApplicationController
  before_action :set_event

  # INDEX /events/1/discounts
  def index
    render json: {
      discounts: @event.discounts.map do |discount|
        {
          id: discount.id,
          description: discount.description,
          valid_until: discount.valid_until.try(:utc).try(:iso8601),
          amount: {
            fractional: discount.fractional,
            currency: discount.currency
          },
          active_when: discount.active_when,
          distribute_among: discount.distribute_among
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
