require 'spec_helper'
describe ProjectsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in FactoryGirl.create(:user) 
  end
  describe "Test routes" do
    it " get new should have respond " do
      get :new
      response.should be_success
      response.code.should == "200"
    end
    it "show should have respond" do
      get "new" 
      response.should be_success
      response.code.should == "200"
    end
  end
end
