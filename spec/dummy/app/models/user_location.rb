# frozen_string_literal: true

class UserLocation < AbstractAdapter
  belongs_to :user
  belongs_to :location
  belongs_to :detectable, polymorphic: true

  validates_inclusion_of :detectable_type, in: %w[LocationBeacon LocationGps]

  default_scope { includes(:detectable).order('created_at desc') }

  # convenience method to set coordinates by an array of [lat,lng,alt]
  def coords=(coords)
    self.lat = coords[0]
    self.lng = coords[1]
    self.alt = coords[2]
  end

  def beacon
    detectable.is_a?(LocationBeacon) ? detectable : {}
  end

  def distance
    return unless location.gps && lat && lng

    location.gps.distance_from(lat, lng)
  end
end
