# frozen_string_literal: true

class LocationBeaconAdmin < IntrospectiveAdmin::Base
  register LocationBeacon do
    scope :all
    scope :low_battery
  end
end
