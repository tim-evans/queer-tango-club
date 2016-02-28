class PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_photo, only: [:destroy]

  # POST /photos
  def create
    photo = Photo.create(photo_params)
    render json: {
      photo: {
        id: photo.id,
        src: photo.src
      }
    }
  end

  def destroy
    event = @photo.event
    @photo.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    def photo_params
      params.require(:photo).permit(:event_id, :attachment)
    end
end
