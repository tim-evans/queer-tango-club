class MapboxService
  QUERY_URL = "https://api.mapbox.com/geocoding/v5/mapbox.places"

  def geolocate(location)
    query = "#{location.address_line}, #{location.city}, #{location.region_code} #{location.postal_code}"

    places = Unirest.get("#{QUERY_URL}/#{query.gsub(' ', '+')}.json?access_token=#{ENV['MAPBOX_TOKEN']}",
                         headers: {
                           'Accept' => 'application/json',
                           'Content-Type' => 'application/json'
                         }).body

    places['features'][0]['center']
  end
end
