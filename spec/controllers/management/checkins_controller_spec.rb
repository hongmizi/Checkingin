# coding: UTF-8
require 'spec_helper'

describe Management::CheckinsController do
  before do
    @manager = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, :owner => @manager)
    @member = FactoryGirl.create(:user)
    FactoryGirl.create(:membership, user_id:@member, project_id:@project)
    @checkin_1 = FactoryGirl.create(:checkin, :project => @project, :user => @member)
    @checkin_2 = FactoryGirl.create(:checkin, :project => @project, :user => @member)
    @checkin_3 = FactoryGirl.create(:checkin, :project => @project, :user => @member)
  end

  describe "GET /index" do
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

  describe "PUT /update" do
    context "unauthorized visitor" do
      sign_in @member
      it "should redirect to the home page" do
        put :update, id:@checkin_1, project_id:@project.id
        response.should redirect_to(new_user_session_path)
      end
    end
    context "authorized visitor" do
      sign_in @manage
     
      it "should could approved the checkin" do
        put :update, id:@checkin_1, state:"approved"
        @checkin_1.state.should == "approved"
      end
  
      it "should could declined the checkin" do
        put :update, id:@checkin_1, state:"declined"
        @checkin_1.state.should == "declined"
      end

      it "should alert if already approved/declined the checkin" do
        put :update, id:@checkin_1, state:"declined"
        put :update, id:@checkin_1, state:"declined"
        flash.alert.should == '你已经审批过了!'
      end
    end
  end
end
