require 'ostruct'

class HomeController < ApplicationController
  def index
    @hero_image = OpenStruct.new({
      width: 2048,
      height: 1365,
      src: 'triple.png'
    })
    @upcoming = Event.where('ends_at >= ?', DateTime.now).order(starts_at: :asc)
  end
end
