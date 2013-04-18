require 'spec_helper'
describe Invitation::InvitesController do
  before do
    @manage = FactoryGirl.create(:user)
    @member = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, user_id:@manage.id)
  end
  describe "POST /create" do
    it "should create the invite" do
      sign_in @manage
    lambda do
      post :create, project_id:@project.id, user_email:@member.email
    end.should change(Invite.all, :count).by(1)
    end
  end

  describe "GET /update" do
    before do
      sign_in @member
      @invite = FactoryGirl.create(:invite, user_id:@manage.id, invited_user_id:@member.id, project_id:@project.id, token:"123456789")
    end
    it "should can approve the invitation" do
      lambda do
        get :update, id:@invite.id, token:"123456789", state:"approved", project_id:@project.id
      end.should change(Membership.all, :count).by(1)
    end
    it "should can decline the invitation" do
      lambda do
        get :update, id:@invite.id, token:"123456789", state:"declined", project_id:@project.id
      end.should change(Membership.all, :count).by(0)
    end
    it "should redirect to root_path if token is wrong" do
        get :update, id:@invite.id, token:"789", state:"declined", project_id:@project.id
        response.should redirect_to root_path
    end
  end
end
