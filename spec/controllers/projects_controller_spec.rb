require 'spec_helper'
describe ProjectsController do
  describe "Get test" do
    it " index should have respond " do
      get :new
      response.should be_success
      response.code.should == "200"
    end
  end
end
