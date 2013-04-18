require 'spec_helper'
describe MembershipsController do
  describe "DELETE /destory" do
    before do
      @owner = FactoryGirl.create(:user)
      @project = FactoryGirl.create(:project, user_id:@owner)
      @member = FactoryGirl.create(:user)
      @visit = FactoryGirl.create(:user)
      FactoryGirl.create(:membership, user_id:@member, project_id:@project)
    end
    context "user is owner of project" do
      sign_in @owner
      it "should destory the membership" do
        lambda do
          delete :destory, project_id:@project, user_id:@member
        end.should change(Membership.all, :count).by(-1)
      end
    end

    context "user is member of project" do
      sign_in @member
      it "should destory the membership" do
        lambda do
          delete :destory, project_id:@project
        end.should change(Membership.all, :count).by(-1)
      end

    end

    context "user is not member or owner of project" do
 sign_in @visit
      it "should destory the membership" do
        lambda do
          delete :destory, project_id:@project
        end.should change(Membership.all, :count).by(0)
      end

    end
  end

end
