require 'spec_helper'

describe Management::CheckinsController do

  describe "GET /index" do
    before do
      @manager = FactoryGirl.create(:user)
      @project = FactoryGirl.create(:project, :owner => @manager)

      @member = FactoryGirl.create(:user)
      @checkin_1 = FactoryGirl.create(:checkin, :project => @project, :user => @member)
      @checkin_2 = FactoryGirl.create(:checkin, :project => @project, :user => @member)
      @checkin_3 = FactoryGirl.create(:checkin, :project => @project, :user => @member)
    end

    context "unauthorized visitor" do
      it "should redirect the visitor to the home page" do
        get :index, member_id:1, project_id:@project.id

        response.should redirect_to(new_user_session_path)
        flash[:alert].should == "You need to sign in or sign up before continuing."
      end
    end

    context "authorized visitor" do
      before do
        sign_in @manager
      end

      it "should list all the checkins of the users" do
        get :index, member_id:@member.id, project_id:@project.id

        assigns[:checkins].count.should == 3
      end
    end
  end
end
