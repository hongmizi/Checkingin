require 'spec_helper'
describe ProjectsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    
    @user = FactoryGirl.create(:user) 
    @project = FactoryGirl.create(:project)
    sign_in @user
  end
  describe "Test routes" do
    it " get new should have respond " do
      get :new
      response.should be_success
      response.code.should == "200"
    end
    it "show should have respond" do
      get :show, id:@project.id
      response.should be_success
      response.code.should == "200"
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
  end
end
