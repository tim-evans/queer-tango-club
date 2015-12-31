class HomeController < ApplicationController
  def index
    @hero_src = ""
    @upcoming = Event.where("starts_at >= ?", DateTime.now).order(starts_at: :asc)
  end
end
