class AttendeesController < ApplicationController
  before_action :set_attendee, only: [:update]

  # PATCH/PUT /attendees/1
  def update
    if @attendee.update(attendee_params)
      render json: {
        attendee: {
          id: @attendee.id,
          name: @attendee.name,
          attended: @attendee.attended
        }
      }
    else
      render status: :unprocessable_entity,
             json: {
               errors: @attendee.errors
             }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendee
      @attendee = Attendee.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def attendee_params
      params.require(:attendee).permit(:attended)
    end
end
