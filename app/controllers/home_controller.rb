require 'ostruct'

class HomeController < ApplicationController
  def index
    @hero_image = OpenStruct.new({
      width: 1280,
      height: 853,
      src: 'nov2016.jpg'
    })
    @upcoming = Event.published.upcoming.order(starts_at: :asc)
  end
end
