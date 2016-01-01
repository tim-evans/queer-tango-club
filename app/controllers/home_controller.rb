class HomeController < ApplicationController
  def protocol
    if Rails.env.production?
      'https://'
    else
      :request
    end
  end

  def index
    @hero_src = view_context.image_url('IMG_4024.jpg', protocol: protocol)
    @upcoming = Event.where('starts_at >= ?', DateTime.now).order(starts_at: :asc)
  end
end
