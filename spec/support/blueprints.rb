# frozen_string_literal: true

require 'machinist/active_record'
require 'rufus/mnemo'

# prevent unique string collisions over the test cycle
def _index
  @_uniq_idx ||= 0
  (@_uniq_idx += 1).to_s(36)
end

def syllable(length = -1)
  s = Rufus::Mnemo.from_integer(rand(8**5) + 1) # + _index
  s[0..length]
end

def word(max_syl = 3)
  (1 + rand(max_syl)).times.collect { syllable }.join
end

def words(count = 3)
  count.times.collect { word }.join
end

def paragraph(count = 25)
  words(count)
end

Company.blueprint do
  name       { words }
  short_name { syllable(10) }
end

User.blueprint do
  email       { "test-#{syllable}@springshot.com" }
  first_name  { word(4) }
  last_name   { word(5) }
  password    { 'abcd1234' }
  confirmed_at { Time.now }
end

Role.blueprint do
  user_id       { User.first || User.make }
  ownable_id    { Company.first || Company.make }
  ownable_type  { 'Company' }
end

Locatable.blueprint do
  location { Location.make }
  locatable { Company.make }
end
Location.blueprint do
  name     { "#{rand(65..72).chr}1" }
  kind     { 'gate' }
  gps      { LocationGps.new(lat: 37.615223, lng: -122.389977) }
end
LocationBeacon.blueprint do
  location  { Location.make! }
  company   { Company.make! }
  mac_address { SecureRandom.hex(6) }
  # e.g. 2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6
  uuid { "#{SecureRandom.hex(4)}-#{SecureRandom.hex(2)}-#{SecureRandom.hex(2)}-#{SecureRandom.hex(2)}-#{SecureRandom.hex(6)}" }
  major { rand(9999) }
  minor { rand(9999) }
end
LocationGps.blueprint do
  location { Location.make }
  # place the point randomly within about a mile radius of the TEST airport (LocationHelper)
  lat { 37.615223   + (0.01609 * rand(0.1) * (rand(2) > 0 ? 1 : -1)) }
  lng { -122.389977 + (0.01609 * rand(0.1) * Math.cos(37.615223 * Math::PI / 180) * (rand(2) > 0 ? 1 : -1)) }
  alt { 0 }
end

Project.blueprint do
  name  { words(2) }
  owner { Company.make }
  jobs { [Job.make, Job.make] }
  admins { [User.make] }
end
Job.blueprint do
  title { words(2) }
end
UserProjectJob.blueprint do
  user    { User.make }
  project { Project.make }
  job     { Job.make }
end
ProjectJob.blueprint do
  project { Project.make }
  job     { Job.make }
end

Team.blueprint do
  p = Project.make
  project { p }
  creator { p.admins.first }
  name { words(2) }
end
TeamUser.blueprint do
  t = Team.make
  t.project.users.push User.make(projects: [t.project])
  team { t }
  user { t.project.users.first }
end
