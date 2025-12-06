# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::LocationBeaconsController, type: :controller do
  render_views

  before :each do # Why can't I do this shit in a helper like I do for requests?
    user = double('user')
    allow(request.env['warden']).to receive(:authenticate!) { user }
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET index' do
    it 'finds all location beacons' do
      c = LocationBeacon.make!(last_known_battery_level: 50)
      d = LocationBeacon.make!(last_known_battery_level: 4)
      get :index
      response.status.should
      assigns(:location_beacons).include?(c).should
      assigns(:location_beacons).include?(d).should == true
    end

    it 'scopes location beacons by low battery level' do
      c = LocationBeacon.make!(last_known_battery_level: 50)
      d = LocationBeacon.make!(last_known_battery_level: 4)
      get :index, params: { scope: 'low_battery' }
      response.status.should
      assigns(:location_beacons).include?(c).should
      assigns(:location_beacons).include?(d).should == true
    end
  end

  describe 'SHOW record' do
    it 'finds the record' do
      c = LocationBeacon.make!
      get :show, params: { id: c.id }
      response.status.should == 200
    end
  end

  describe 'NEW record' do
    # will fail until https://github.com/activeadmin/activeadmin/pull/4010 is merged
    it 'renders the form for a new record' do
      get :new
      response.status.should == 200
    end
  end

  describe 'CREATE record' do
    it 'creates the record' do
      c = LocationBeacon.make
      post :create, params: { location_beacon: c.attributes }
      response.should redirect_to action: :show, id: LocationBeacon.last.id
      LocationBeacon.last.mac_address.should =~ /#{c.mac_address}/i
    end
  end

  describe 'EDIT record' do
    it 'renders the edit form for an existing record' do
      r = LocationBeacon.make!
      get :edit, params: { id: r.id }
      response.status.should == 200
    end
  end

  describe 'UPDATE record' do
    it 'updates the record' do
      r = LocationBeacon.make!
      put :update, params: { id: r.id, location_beacon: { last_known_battery_level: 30 } }
      response.should redirect_to action: :show, id: r.id
      LocationBeacon.find(r.id).last_known_battery_level.should == 30
    end
  end
end
