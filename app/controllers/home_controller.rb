require 'ostruct'

class HomeController < ApplicationController
  def index
    @hero_image = OpenStruct.new({
      width: 3147,
      height: 2098,
      src: 'triple.jpg'
    })
    @upcoming = Event.where('ends_at >= ?', DateTime.now).order(starts_at: :asc)
  end
end
