class HomeController < ApplicationController
  def index
    @hero_src = view_context.image_url('IMG_4024.jpg', protocol: :relative)
    @upcoming = Event.where('starts_at >= ?', DateTime.now).order(starts_at: :asc)
  end
end
