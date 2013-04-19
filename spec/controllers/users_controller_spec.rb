# coding: UTF-8
require 'spec_helper'
describe UsersController do
  before do
    @user = FactoryGirl.create(:user,:nickname => "test")
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
    it "should change name" do
      put :update, :nickname => "abc"
      @user.reload
      @user.nickname.should == "abc"
    end

    it "should not change name if no nickname provided" do
      put :update, nickname:""
      @user.reload
      @user.nickname.should == "test"
    end

    it "should return an error message if nickname not saved" do
      foobar = double(:user)
      controller.stub(:current_user) {foobar}
      foobar.should_receive(:save).and_return(false)
      foobar.stub!(:nickname=)

      put :update, :nickname => "abc"
      flash.alert.should == "更改名字失败！"
      response.should redirect_to "/profile"
    end
  end
end

