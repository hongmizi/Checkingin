require 'spec_helper'
describe CheckinsController do
  before do
    @manage = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, user_id:@manage.id)
    @member = FactoryGirl.create(:user)
    FactoryGirl.create(:membership, project_id:@project.id, user_id:@member.id)
  end

  describe "GET /index" do
    it "should visit index page" do
      sign_in @member
      get :index
      response.code.should == "200"
    end
  end

  describe "POST /create" do
    before do
      sign_in @member
    end

    it "should can check in" do
      lambda do
        post :create, project_id:@project.id
      end.should change(Checkin.all, :count).by(1) #reload!
    end

    it "should can not check in if user already checkin" do
    @checkin_1 = FactoryGirl.create(:checkin, user_id:@member.id, project_id:@project.id)
      lambda do
        post :create, project_id:@project.id
      end.should change(Checkin.all, :count).by(0)

    end
  end
end
