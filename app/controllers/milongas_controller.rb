class MilongasController < ApplicationController
  before_action :set_milonga, only: [:show]

  # GET /milongas
  def index
    @milongas = Milonga.all
  end

  # GET /milongas/1
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_milonga
      @milonga = Milonga.find(params[:id])
    end
end
