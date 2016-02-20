class PrivatesController < ApplicationController
  before_action :set_private, only: [:show, :inquire]

  # GET /events/1/privates/1
  def show
  end

  # POST /events/1/privates/1/inquire
  def inquire
    errors = []
    errors << "Please provide your name so we know who you are."  if params[:name].blank?
    errors << "We need your email to get in touch with you."      if params[:email].blank?
    errors << "When would you like to attend the private?"        if params[:body].blank?
    if errors.blank?
      PrivatesMailer.inquire(@private, "\"#{params[:name]}\" <#{params[:email]}>", params[:body]).deliver!
    else
      flash[:error] = errors
      redirect_to event_private_path(@event, @private)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_private
      @event = Event.find(params[:event_id])
      @private = @event.privates.find(params[:id])
    end
end
