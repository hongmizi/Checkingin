require 'spec_helper'
describe UsersController do
  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  describe "GET /profile" do
   it "should visit the page" do
     get :profile
      response.code.should == "200"
    end
  end

  describe "GET /show" do
    it "should visit the page" do
      get :show, id:@user.id
      response.code.should == "200"
    end
  end

  describe "PUT /update" do
    it "should could change name" do
      put :update, :nickname => "abc"
      @user.reload
      @user.nickname.should == "abc"
    end

    it "should not change name if don't post name" do
      put :update, nickname:""
      @user.reload
      @user.nickname.should == nil
    end
  end
end

