require 'ostruct'

class HomeController < ApplicationController
  def index
    @hero_image = OpenStruct.new({
      width: 3147,
      height: 2098,
      src: 'IMG_3986.png'
    })
    @upcoming = Event.where('starts_at >= ?', DateTime.now).order(starts_at: :asc)
  end
end
