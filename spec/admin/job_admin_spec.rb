require 'rails_helper'

RSpec.describe Admin::JobsController, :type => :controller do 
  render_views

  before :each do # Why can't I do this shit in a helper like I do for requests?
    user = double('user')
    allow(request.env['warden']).to receive(:authenticate!) { user }
    allow(controller).to receive(:current_user) { user }
  end

  describe "GET index" do
    it "finds all Jobs" do
      r = Job.make!
      get :index
      response.status.should == 200 
      assigns(:jobs).include?(r).should == true
    end
  end

  describe "SHOW record" do 
    it "finds the record" do
      r = Job.make!
      get :show, id: r.id
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
      r = Job.make
      post :create, job: r.attributes
      response.should redirect_to action: :show, id: Job.last.id
      Job.last.title.should == r.title
    end
  end

  describe "EDIT record" do 
    it "renders the edit form for an existing record" do 
      r = Job.make!
      get :edit, id: r.id
      response.status.should == 200 
    end
  end

  describe "UPDATE record" do 
    it "updates the record" do
      r = Job.make!
      put :update, id: r.id, job: { title: "New Name" } 
      response.should redirect_to action: :show, id: r.id
      Job.find(r.id).title.should == "New Name"
    end
  end
end
