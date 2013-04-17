# coding: UTF-8
require "spec_helper"
describe ProjectsController do
  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user) 
    @project = FactoryGirl.create(:project)
  end
  describe "#index" do
  end
  describe "#show" do
    before do 
    sign_in @user
    end
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
    before do
      sign_in @user
    end
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
      @project = FactoryGirl.create(:project, user_id:@admin.id)
    end
    
    context "if user not is admin" do
      before do 
        sign_in @user
      end

      it "should can't manage project "  do
        put :update, id:@project.id
        response.code.should == "302"
        response.should redirect_to root_path
      end
    end

    context "signed in  is admin " do
      before do
        sign_in @admin
      end

      it "should not added admin to the project" do
        put :update, id:@project.id, new_member:@admin.id
        flash.alert.should == "你不能添加自己为项目成员..."
      end

      it "should add a user" do
        put :update, id:@project.id, new_member:@user.id
        (@project.users.include? @user.id).should == true
      end
      it "added user should not is member of project" do
        Membership.create!(user_id:@admin.id, project_id:@project.id)
        put :update, id:@project.id, new_member:@user.id
        flash.alert.should == "此用户已经在项目中了.."
      end
    end

  end

end
