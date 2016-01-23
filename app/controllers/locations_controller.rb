class LocationsController < ApplicationController
  before_action :set_location, only: [:show]

  # GET /locations/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end
end
