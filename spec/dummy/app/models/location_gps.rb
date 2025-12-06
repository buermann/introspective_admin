# frozen_string_literal: true

class LocationGps < AbstractAdapter
  belongs_to :location
  has_many :beacons, through: :location

  # lat and lng in degrees altitude in meters
  validates_numericality_of :lat, greater_than_or_equal_to: -90.0, less_than_or_equal_to: 90.0
  validates_numericality_of :lng, greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0
  validates_numericality_of :alt
end
