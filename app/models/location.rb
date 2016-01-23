class Location < ActiveRecord::Base
  belongs_to :event_location, class_name: 'Location'
  has_many :nearby_locations, class_name: 'Location',
                              foreign_key: 'event_location_id'

  has_attached_file :photo, styles: { wide: 'x400', thumbnail: '400x' }
  validates_attachment_content_type :photo, content_type: %w(image/jpeg image/jpg image/png)

  before_create :geolocate

  def geolocate
    return if latitude && longitude

    lon, lat = MapboxService.new.geolocate(self)
    self.longitude = lon
    self.latitude = lat
    true
  end

  def slug
    name.parameterize
  end

  def inside?(location)
    location.longitude == longitude &&
      location.latitude == latitude
  end

  def directions_url(origin=nil)
    if origin
      "https://www.google.com/maps/dir/#{origin.latitude},#{origin.longitude}/#{latitude},#{longitude}/@#{latitude},#{longitude},15z"
    else
      "https://www.google.com/maps/dir//#{latitude},#{longitude}/@#{latitude},#{longitude},15z"
    end
  end
end
