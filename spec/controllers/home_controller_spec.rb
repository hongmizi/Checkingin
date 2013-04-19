require 'spec_helper'
describe HomeController do
  before do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, user_id:@user.id)
    sign_in @user
  end
  describe "GET /index" do
    it "should get response" do
      get :index
      response.code.should == "200"
    end
  end
end
