class HomeController < ApplicationController
  def index
    @hero_src = 'IMG_3986.png'
    @upcoming = Event.where('starts_at >= ?', DateTime.now).order(starts_at: :asc)
  end
end
