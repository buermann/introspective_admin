# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Admin::ProjectsController, type: :controller do
  render_views

  before :each do # Why can't I do this shit in a helper like I do for requests?
    user = double('user')
    allow(request.env['warden']).to receive(:authenticate!) { user }
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET index' do
    it 'finds all projects' do
      r = Project.make!
      get :index
      response.status.should
      assigns(:projects).include?(r).should == true
    end
  end

  describe 'SHOW record' do
    it 'finds the record' do
      r = Project.make!
      get :show, params: { id: r.id }
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
      r = Project.make
      post :create, params: { project: r.attributes }
      response.should redirect_to action: :show, id: Project.last.id
      Project.last.name.should == r.name
    end

    it 'the inverse_of declaration allows a new project to be created with a project_job' do
      j = Job.make!
      r = Project.make
      post :create, params: { project: r.attributes.merge({ project_jobs_attributes: { '0'=>{ job_id: j.id } } }) }
      p = Project.last
      p.name.should
      r.name
      p.project_jobs.size.should
      p.project_jobs.first.job.should == j
    end
  end

  describe 'EDIT record' do
    it 'renders the edit form for an existing record' do
      r = Project.make!
      get :edit, params: { id: r.id }
      response.status.should == 200
    end
  end

  describe 'UPDATE record' do
    it 'updates the record' do
      r = Project.make!
      put :update, params: { id: r.id, project: { name: 'New Name' } }
      response.should redirect_to action: :show, id: r.id
      Project.find(r.id).name.should == 'New Name'
    end
  end
end
