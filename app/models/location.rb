class Location < ActiveRecord::Base
  has_many :nearby_locations, class_name: 'Location',
                              foreign_key: 'event_location_id'

  has_attached_file :photo, styles: { wide: 'x400', thumbnail: '400x' }

  before_create :geolocate

  def geolocate
    return if latitude && longitude

    lon, lat = MapboxService.new.geolocate(self)
    self.longitude = lon
    self.latitude = lat
    true
  end

  def directions_url(origin=nil)
    if origin
      "https://www.google.com/maps/dir/#{origin.latitude},#{origin.longitude}/#{latitude},#{longitude}/@#{latitude},#{longitude},15z"
    else
      "https://www.google.com/maps/dir//#{latitude},#{longitude}/@#{latitude},#{longitude},15z"
    end
  end
end
