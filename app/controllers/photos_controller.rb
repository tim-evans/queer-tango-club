class PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_photo, only: [:delete]

  # POST /photos
  def create
    photo = Photo.create(photo_params)
    redirect_to(photos_event_path(photo.event))
  end

  def delete
    event = @photo.event
    @photo.destroy
    redirect_to(photos_event_path(event))
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
