require 'spec_helper'
describe ProjectsController do
  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user) 
    @project = FactoryGirl.create(:project)
    sign_in @user
  end
  describe "#index" do
  end
  describe "#show" do
    context "when user is member of project" do
      before do
        @project = FactoryGirl.create(:project, user_id:@user.id)
      end
      it "should can visit the project" do
        get :show, id:@project.id
        response.code.should == '200'
      end
    end
    context "when user is not member of project" do
      it "should can not visit the project" do
          get :show, id:@project.id
          response.should redirect_to root_path
          response.code.should == "302"
      end
    end
  end

  describe "#create" do
    it "should create project if project have name and description" do
      post :create, :project => {name:@project.name, description:@project.description}
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
    before do 
      @admin = FactoryGirl.create(:user)
    #  @member = FactoryGirl.create(:user)
      @project = FactoryGirl.create(:project, user_id:@admin.id)
    end
    it "should have exist project id" do
      put :update, id:-1
      response.code.should == "302"
      response.should redirect_to user_path(@user.id)
    end
    it "should can't manage project if user not is  the project manage"  do
      put :update, id:@project.id
      response.code.should == "302"
      response.should redirect_to project_path @project.id
    end
  end

end





=begin
     describe "Test routes" do
    it " get new should have respond " do
      get :new
      response.should be_success
      response.code.should == "200"
    end
    it "it user not is project member should have respond 302" do
      get :show, id:@project.id
      response.should_not be_success
      response.code.should == "302"
    end
    it "create should have respond" do
      post :create, name:@project.name, description:@project.description
      response.should be_success
      response.code.should == "200"
    end
    it "update should have respond" do
      put :update, id:@project, new_member:@user.email
     # response.should be_success
      response.code.should == "302"
    end
=end
