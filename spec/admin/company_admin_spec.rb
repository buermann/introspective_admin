require 'rails_helper'

RSpec.describe Admin::CompaniesController, :type => :controller do 
  render_views

  before :each do 
    user = double('user')
    allow(request.env['warden']).to receive(:authenticate!) { user }
    allow(controller).to receive(:current_user) { user }
  end

  describe "GET index" do
    it "finds all companies" do
      c = Company.make!
      get :index
      response.status.should == 200 
      assigns(:companies).include?(c).should == true
    end
  end

  describe "SHOW record" do 
    it "finds the record" do
      c = Company.make!
      get :show, params: { id: c.id }
      response.status.should == 200 
    end
  end

  describe "NEW record" do 
    it "renders the form for a new record" do
      get :new
      response.status.should == 200 
    end
  end

  describe "CREATE record" do 
    it "creates the record" do
      c = Company.make
      post :create, params: { company: c.attributes }
      response.should redirect_to action: :show, id: Company.last.id
      Company.last.name.should == c.name
    end

    it "creates a record with an admin" do
      u = User.make!
      c = Company.make
      post :create, params: { company: c.attributes.merge({
        roles_attributes: {'0'=>{ user_id: u.id }}
      }) }
      response.should redirect_to action: :show, id: Company.last.id
      Company.last.admins.include?(u).should be_truthy
    end

  end

  describe "EDIT record" do 
    it "renders the edit form for an existing record" do 
      r = Company.make!
      get :edit, params: { id: r.id }
      response.status.should == 200 
    end
  end

  describe "UPDATE record" do 
    it "updates the record" do
      c = Company.make!
      put :update, params: { id: c.id, company: { name: "New Name" }  }
      response.should redirect_to action: :show, id: c.id
      Company.find(c.id).name.should == "New Name"
    end
  end
end
