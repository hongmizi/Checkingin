require 'spec_helper'
describe UserDomain do
  before do
    @user = FactoryGirl.create(:user, nickname:"test")
  end
  it "should return nickname if  user have nickname " do
    name = UserDomain.get_user_name @user.id
    name.should == "test"
  end

  it "shold return email if user don't have nickname" do
    @user.nickname = ""
    @user.save
    name = UserDomain.get_user_name @user.id
    name.should == @user.email
  end

  it "should return email if user have nil nickname"do
    @user.nickname = nil
    @user.save
    name = UserDomain.get_user_name @user.id
    name.should == @user.email
  end
end
