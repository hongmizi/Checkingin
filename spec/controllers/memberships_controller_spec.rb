# coding:UTF-8
require "spec_helper"

describe MembershipsController do

    describe "DELETE /destory" do
      before do
        @owner = FactoryGirl.create(:user)
        @project = FactoryGirl.create(:project, user_id:@owner.id)
        @member = FactoryGirl.create(:user)
        @visit = FactoryGirl.create(:user)
        FactoryGirl.create(:membership, user_id:@member.id, project_id:@project.id)
      end
      context "user is owner of project" do
        it "should destory the membership" do
          sign_in @owner
          lambda do
            delete :destroy, project_id:@project.id, user_id:@member.id
          end.should change(Membership, :count).by(-1)
        end
      end

      context "user is member of project" do
         it "should destory the membership" do
          sign_in @member
          lambda do
            delete :destroy, project_id:@project.id
          end.should change(Membership, :count).by(-1)
        end

      end

      context "user is not member or owner of project" do
        it "should destory the membership" do
          sign_in @visit
          lambda do
            delete :destroy, project_id:@project.id
          end.should change(Membership, :count).by(0)
        end

      end
    end
  end
