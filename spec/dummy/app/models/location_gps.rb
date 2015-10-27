class LocationGps < AbstractAdapter
  belongs_to :location
  has_many :beacons, through: :location

  # lat and lng in degrees altitude in meters
  validates_numericality_of :lat, greater_than_or_equal_to: -90.0, less_than_or_equal_to: 90.0
  validates_numericality_of :lng, greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0
  validates_numericality_of :alt

  def distance_from(lat,lng) # calc distance between this location and the passed coords
    Haversine.distance(self.lat,self.lng, lat,lng).to_meters
  end

  class << self
    def bounding_box(lat,lng,alt)  
      # box constrain the nearest neighbor search to something reasonble
      box = 0.1447 # 10 miles radius: 111132 meters/deg, 1609m a mile, 0.01447 deg to a mile
      alt_box = 8  # we're trying to constrain the box to a floor of a building here...
      ["lat BETWEEN :lat-#{box} AND :lat+#{box} AND
       lng BETWEEN :lng-#{box} AND :lng+#{box} AND
       alt BETWEEN :alt-#{alt_box} AND :alt+#{alt_box}",
       { lat: lat, lng: lng, alt: alt } ]
    end

    def nearest_beacon(lat, lng, alt=0, companies)
      company_ids = companies.kind_of?(Array) ? companies : [companies]

      gps = nearest_approximation(lat,lng,alt).joins(:beacons).where("location_beacons.company_id"=>company_ids).first || ( raise ActiveRecord::RecordNotFound.new("Couldn't find a Beacon for that GPS Location.") )
      # It's not clear, if they're doing this across multiple companies, how which beacon
      # comes back is not arbitrary, so maybe we should require it be specific.
      gps.beacons.where(company_id: company_ids).first
    end

    def nearest(lat,lng,alt=0) 
      nearest_approximation(lat,lng,alt).first || ( raise ActiveRecord::RecordNotFound.new("Couldn't find GPS Location.") )
    end

    def nearest_approximation(lat,lng,alt=0) # approximate as a flat-ish plane
      dOrder= sanitize_sql_array(["(lat - ?)^2 + (lng - ?)^2 * COS(RADIANS(lat))", lat, lng])

      self.select("location_gps.id, location_gps.location_id, #{dOrder} as dOrder").
      where( bounding_box(lat,lng,alt) ).order("dOrder ASC")
    end

    def nearest_great_circle(lat,lng,alt=0)
      dOrder = sanitize_sql_array(["acos( sin(radians(lat))*sin(radians(:lat)) + cos(radians(lat))*cos(radians(:lat))*cos(radians(lng - :lng)) )", { lat: lat, lng: lng } ] )

      self.select("location_gps.id, location_gps.location_id, #{dOrder} as dOrder").
      where( bounding_box(lat,lng,alt) ).order("dOrder ASC")
    end

    def nearest_haversine(lat,lng,alt=0)
      dOrder = sanitize_sql_array(["asin( sqrt( (sin(radians(:lat - lat))/2)^2 + cos(radians(lat))*cos(radians(:lat))*(sin(radians(:lng - lng )/2))^2 ))", { lat: lat, lng: lng }])

      self.select("location_gps.id, location_gps.location_id, #{dOrder} as dOrder").
      where( bounding_box(lat,lng,alt) ).order("dOrder ASC")
    end

    #def nearest_wgs84(lat,lng,alt=0)
    #  # vincenty's ellipsoid calculation is an iterative estimate available in postGIS
    #end
  end

end
