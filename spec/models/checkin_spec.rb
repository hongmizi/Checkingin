require 'spec_helper'

describe Checkin do
  before do 
    @apple = Checkin.new(:user_id => 1,:project_id => 1, :state => "pending")
  end
  it "should work if have user_id and project_id and state" do
    @apple.save.should == true
  end

  it "should have user_id" do
    @apple.user_id = nil
    @apple.save.should == false
  end

  it "should have project_id " do
    @apple.project_id = nil
    @apple.save.should == false
  end

  it "should have state " do
    @apple.state = ""
    @apple.save.should == false
  end
end
