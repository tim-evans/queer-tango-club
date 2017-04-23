class Location < ActiveRecord::Base
  include PgSearch

  belongs_to :group
  # belongs_to :photo, dependent: :destroy
  belongs_to :event_location, class_name: 'Location'
  has_many :nearby_locations, class_name: 'Location',
                              foreign_key: 'event_location_id'

  has_attached_file :photo, { preserve_files: true }
  before_save :geolocate

  pg_search_scope :search_for, against: %w(name address_line city), using: [:dmetaphone], ignoring: :accents

  def geolocate
    return unless region_code_changed? || city_changed? || postal_code_changed? ||
                  address_line_changed? || extended_address_changed?

    lon, lat = MapboxService.new.geolocate(self)
    self.longitude = lon
    self.latitude = lat
    true
  end

  def slug
    name.try(:parameterize)
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

  def to_s
    address = [address_line, extended_address].compact.join(' ')
    "#{address} #{city}, #{region_code}, #{postal_code}"
  end
end
