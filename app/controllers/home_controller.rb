require 'ostruct'

class HomeController < ApplicationController
  def index
    @hero_image = OpenStruct.new({
      width: 2048,
      height: 1867,
      src: 'may2016.png'
    })
    @upcoming = Event.published.upcoming.order(starts_at: :asc)
  end
end
