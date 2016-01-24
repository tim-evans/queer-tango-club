class HomeController < ApplicationController
  def index
    @hero_src = 'IMG_3562.jpg'
    @upcoming = Event.where('starts_at >= ?', DateTime.now).order(starts_at: :asc)
  end
end
