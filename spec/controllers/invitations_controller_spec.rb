# coding: UTF-8

require 'spec_helper'
describe InvitationsController do
  before do
    @manager = FactoryGirl.create(:user)
    @member = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, user_id:@manager.id)
  end

  describe "POST /create" do
    before do
      sign_in @manager
    end

    it "should create the invite" do
      lambda do
        post :create, project_id:@project.id, user_email:@member.email
      end.should change(Invite, :count).by(1)
    end

    it "should show an error message if the invitation fails" do
      invitation = double(:invitation)
      Invite.should_receive(:new).and_return(invitation)
      invitation.should_receive(:save).and_return(false)

      lambda do
        post :create, project_id:@project.id, user_email:@member.email
      end.should change(Invite, :count).by(0)

      flash[:alert].should == '邀请失败!'
    end
  end

  describe "GET /update" do
    before do
      sign_in @member
      @invite = FactoryGirl.create(:invite, user_id:@manager.id, invited_user_id:@member.id, project_id:@project.id, token:"123456789")
    end
    it "should can approve the invitation" do
      lambda do
        get :update, id:@invite.id, token:"123456789", state:"approved", project_id:@project.id
      end.should change(Membership, :count).by(1)
    end
    it "should can decline the invitation" do
      lambda do
        get :update, id:@invite.id, token:"123456789", state:"declined", project_id:@project.id
      end.should change(Membership, :count).by(0)
    end

    it "should redirect to user_path if state is wrong" do
      lambda do
        get :update, id:@invite.id, token:"123456789", state:"abc", project_id:@project.id
      end.should change(Membership, :count).by(0)
    end

    it "should redirect to root_path if token is wrong" do
      get :update, id:@invite.id, token:"789", state:"declined", project_id:@project.id
      response.should redirect_to root_path
    end
  end
end
