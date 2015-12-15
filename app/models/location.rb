class Location < ActiveRecord::Base
  before_create :geolocate

  def geolocate
    return if latitude && longitude

    lon, lat = MapboxService.new.geolocate(self)
    self.longitude = lon
    self.latitude = lat
    true
  end

  def map_url(width: 300, height: 300)
    "https://api.mapbox.com/v4/mapbox.light/pin-m+FF3800(#{longitude},#{latitude})/#{longitude},#{latitude},15/#{width}x#{height}@2x.png?access_token=#{ENV['MAPBOX_TOKEN']}"
  end

  def directions_url
    "https://www.google.com/maps/dir//#{latitude},#{longitude}/@#{latitude},#{longitude},15z"
  end
end
