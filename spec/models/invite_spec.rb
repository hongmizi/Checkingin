require 'spec_helper'

describe Invite do
  before do
    @invite = FactoryGirl.create(:invite) 
  end
  it "shoud can save if have all thing " do
    @invite.save.should == true
  end
  describe "shoud validate the present" do
      it "shoud have invited_user_id" do
        @invite.invited_user_id = nil
        @invite.save.should == false
      end
      it "should have project_id " do
        invite = FactoryGirl.create(:invite) 
        invite.project_id = nil
        invite.save.should == false
        invite.errors[:project_id].should == ["can't be blank"]
      end
      it "should have user_id " do
        @invite.save.should == true
        @invite.user_id = nil
        @invite.save.should == false
        @invite.errors[:user_id].should == ["can't be blank"]
      end
  end
  describe "state machine" do
    it "shoud be pending first" do
      @invite.state.should == "pending"
    end
    it "should change to approved if approved it" do
      @invite.approve
      @invite.reload
      @invite.state.should == "approved"
  end
    it "shoud change to declined if declined it" do
      @invite.decline
      @invite.reload
      @invite.state.should == "declined"
    end
  end
end
