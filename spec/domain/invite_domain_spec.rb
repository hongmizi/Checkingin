require 'spec_helper'
describe InviteDomain do
  before do
    @manager = FactoryGirl.create(:user)
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, user_id:@manager.id)
    @invite = FactoryGirl.create(:invite, user_id:@manager.id, project_id:@project.id, invited_user_id:@user.id)
  end
  it "should approved_invit" do
    lambda do
      InviteDomain.approved_invite @invite.id
    end.should change(Membership, :count).by(1)
    Membership.last.user_id.should == @user.id
    Membership.last.project_id.should == @project.id
  end

  it "should not approved_invite if user already in project" do
    FactoryGirl.create(:membership, user_id:@user.id, project_id:@project.id)
    lambda do
      InviteDomain.approved_invite @invite.id
    end.should change(Membership, :count).by(0)
  end

end
