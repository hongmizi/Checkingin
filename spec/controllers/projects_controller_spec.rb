require 'spec_helper'
describe ProjectsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @admin = User.first
    sign_in @admin
    #wiserwx=  User.last
    #sign_in @wiserwx
  end
  describe "Get test" do
    it " index should have respond " do
      get :new
      response.should be_success
      response.code.should == "200"
    end
  end
end
