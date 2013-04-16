require 'spec_helper'

describe MembershipController do

  describe "GET 'destory'" do
    it "returns http success" do
      get 'destory'
      response.should be_success
    end
  end

end
