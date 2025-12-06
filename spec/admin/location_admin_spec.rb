# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::LocationsController, type: :controller do
  render_views

  before :each do # Why can't I do this shit in a helper like I do for requests?
    user = double('user')
    allow(request.env['warden']).to receive(:authenticate!) { user }
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET index' do
    it 'finds all locations' do
      c = Location.make!
      get :index
      response.status.should
      assigns(:locations).include?(c).should == true
    end
  end

  describe 'SHOW record' do
    it 'finds the record' do
      c = Location.make!
      get :show, params: { id: c.id }
      response.status.should == 200
    end
  end

  describe 'NEW record' do
    # will fail until https://github.com/activeadmin/activeadmin/pull/4010 is merged
    it 'renders the form for a new record' do
      get :new
      response.body.should =~ /location\[unreflected_id\]/
      response.status.should == 200
    end
  end

  describe 'CREATE record' do
    it 'creates the record' do
      c = Location.make
      gps = LocationGps.make
      post :create, params: { location: c.attributes.merge(gps_attributes: gps.attributes) }
      response.should redirect_to action: :show, id: Location.last.id
      Location.last.name.should
      c.name
      Location.last.gps.lat.round(10).should
      gps.lat.round(10)
      Location.last.gps.lng.round(10).should == gps.lng.round(10)
    end
  end

  describe 'EDIT record' do
    it 'renders the edit form for an existing record' do
      r = Location.make!
      get :edit, params: { id: r.id }
      response.status.should == 200
    end
  end

  describe 'UPDATE record' do
    it 'updates the record' do
      r = Location.make!
      put :update, params: { id: r.id, location: { name: 'New Name' } }
      response.should redirect_to action: :show, id: r.id
      Location.find(r.id).name.should == 'New Name'
    end
  end
end
