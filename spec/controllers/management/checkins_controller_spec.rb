# coding: UTF-8
require 'spec_helper'

describe Management::CheckinsController do
  before do
    @manager = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, :user_id => @manager.id)
    @member = FactoryGirl.create(:user)
    FactoryGirl.create(:membership, user_id:@member.id, project_id:@project.id)
    @checkin_1 = FactoryGirl.create(:checkin, :project_id => @project.id, :user => @member)
    @checkin_2 = FactoryGirl.create(:checkin, :project_id => @project.id, :user => @member)
    @checkin_3 = FactoryGirl.create(:checkin, :project_id => @project.id, :user => @member)
  end

  describe "GET /index" do
    context "unauthorized visitor" do
      it "should redirect the sign_in page" do
        get :index, member_id:1, project_id:@project.id
        flash[:alert].should == "You need to sign in or sign up before continuing."
        response.code.should == "302"
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
      
      it "should list null if query a wrong time" do
        get :index, member_id:@member.id, project_id:@project.id, year:2000, month:1
        assigns[:checkins].count.should == 3
        assigns[:checkins_on_month].select {|k,v| v }.count.should == 0 
      end

    end
  end

  describe "GET /update" do # Email authorize
    context "unauthorized visitor" do
      before  do 
        sign_in @member
      end
      it "should redirect 404" do
        get :update, id:@checkin_1.id, project_id:@project.id
        response.code.should == "404"
      end
    end
    context "authorized visitor" do
      before do 
        sign_in @manager
      end
      it "should could approved the checkin" do
        get :update, id:@checkin_1.id, state:"approved", project_id:@project.id
        @checkin_1.reload
        @checkin_1.state.should == "approved"
      end
  
      it "should could declined the checkin" do
        get :update, id:@checkin_1.id, state:"declined", project_id:@project.id
        @checkin_1.reload
        @checkin_1.state.should == "declined"
      end

      it "should alert if already approved/declined the checkin" do
        get :update, id:@checkin_1.id, state:"declined", project_id:@project.id
        get :update, id:@checkin_1.id, state:"declined", project_id:@project.id
        flash.alert.should == '你已经审批过了!'
      end
    end
  end
end
