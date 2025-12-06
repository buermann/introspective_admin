# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  render_views

  before :each do
    user = double('user')
    allow(request.env['warden']).to receive(:authenticate!) { user }
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET index' do
    it 'finds all users' do
      u = User.make!
      get :index
      response.status.should
      assigns(:users).include?(u).should == true
    end
  end

  describe 'SHOW record' do
    it 'finds the record' do
      u = User.make!
      get :show, params: { id: u.id }
      response.status.should == 200
    end
  end

  describe 'NEW record' do
    it 'renders the form for a new record' do
      get :new
      response.status.should == 200
    end
  end

  describe 'CREATE record' do
    it 'creates the record' do
      post :create, params: { user: { first_name: 'first', last_name: 'last', email: 'test@blah.com', password: 'abcd1234' } }
      response.should redirect_to action: :show, id: User.last.id
      u = User.last
      u.first_name.should
      u.last_name.should
      u.email.should == 'test@blah.com'
    end
  end

  describe 'EDIT record' do
    it 'renders the edit form for an existing record' do
      r = User.make!
      get :edit, params: { id: r.id }
      response.status.should == 200
    end
  end

  describe 'UPDATE record' do
    it 'updates the record' do
      u = User.make!
      put :update, params: { id: u.id, user: { first_name: 'New Name' } }
      response.should redirect_to action: :show, id: u.id
      User.find(u.id).first_name.should == 'New Name'
    end
  end
end
