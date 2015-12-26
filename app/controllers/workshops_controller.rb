class WorkshopsController < ApplicationController
  before_action :set_workshop, only: [:show]

  # GET /workshops
  def index
    @workshops = Workshop.all.order(starts_at: :desc)
  end

  # GET /workshops/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workshop
      @workshop = Workshop.find(params[:id])
    end
end
