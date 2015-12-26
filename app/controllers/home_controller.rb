class HomeController < ApplicationController
  def index
    @hero_src = ""
    @upcoming = Event.where("starts_at >= ?", DateTime.now)
  end
end
