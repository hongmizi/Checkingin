require 'spec_helper'

describe Checkin do
  before do 
    @apple = Checkin.new(:user_id => 1,:project_id => 1, :state => "pending")
  end
  it "should work if have user_id and project_id and state" do
    @apple.save.should == true 
  end

  it "should validate presence of  user_id" do
    @apple.user_id = nil
    @apple.valid?
    @apple.errors[:user_id].should == ["can't be blank"]
  end

  it "should validate presence of project_id " do
    @apple.project_id = nil
    @apple.valid?
    @apple.errors[:project_id].should == ["can't be blank"]
  end

  it "should validate presence of state " do
    @apple.state = ""
    @apple.valid?
    @apple.errors[:state].should ==  ["can't be blank", "is invalid"]
  end


  describe "state machine" do
    it "should be pending at first" do
      @apple.state.should == "pending"
    end

    it "should change to approved if the user approve the checkin" do
      @apple.save
      @apple.approve!
      @apple.reload
      @apple.state.should == "approved"
    end
    it "should change too decline if the user decline the checkin" do
      @apple.decline!
      @apple.reload
      @apple.state.should == "declined"
    end
  end
end
