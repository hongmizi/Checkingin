# coding: UTF-8
require "spec_helper"
describe ProjectsController do
  before :each do
    @user = FactoryGirl.create(:user) 
    @project = FactoryGirl.create(:project)
  end

  describe "GET /index" do
  end

  describe "GET /show" do
    before do 
      sign_in @user
    end

    context "user is owner of project" do
      before do
        @project = FactoryGirl.create(:project, user_id:@user.id)
      end

      it "should can visit the project" do
        get :show, id:@project.id
        response.code.should == '200'
      end
    end

    context "user is not member of project" do
      it "should can not visit the project" do
        get :show, id:@project.id
        response.should redirect_to root_path
        response.code.should == "302"
      end
    end
  end

  describe "GET /new" do
    it "should response 200" do
      sign_in @user
      get :new
      response.code.should == "200"
    end
  end
  describe "POST /create" do
    before do
      sign_in @user
    end

    it "should create project if project have name and description" do
      lambda do
        post :create, :project => {name:@project.name, description:@project.description}
      end.should change(@user.projects, :count).by(1)

      response.should redirect_to user_path(@user.id)
    end

    it "should  not create project if project  don't have name " do
      post :create, :project => {name:"", description:@project.description}
      response.code.should == "200" # render to "new"
    end

    it "should  not create project if project  don't have description" do
      post :create, :project => {name:@project.name, description:""}
      response.code.should == "200" # render to "new"
    end
  end

  describe "#update" do
  end
end
