require 'spec_helper'
require 'date'
describe CheckinDomain do
  before do
    @manager = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, user_id:@manager.id)
    @member = FactoryGirl.create(:user)
    FactoryGirl.create(:membership, user_id:@member.id, project_id:@project.id)
    @now = DateTime.now
    @checkin_1 = FactoryGirl.create(:checkin, user_id:@member.id, project_id:@project.id, created_at:@now-1)
    @checkin_2 = FactoryGirl.create(:checkin, user_id:@member.id, project_id:@project.id, created_at:@now)
    @checkin_3 = FactoryGirl.create(:checkin, user_id:@member.id, project_id:@project.id, created_at:@now+1)
  end

  it "should get user checkins on month" do
    checkins = CheckinDomain.new.get_user_checkins_on_month @now, @member.id, @project.id
    checkins.count.should == Time.days_in_month(@now.month,@now.year)
    count = 0
    checkins.each do |k, v|
      count+=1 if v
    end
    count.should == 3
  end

  it "should get user checkins count in project" do
    @checkin_1.approve
    @checkin_3.decline
    count = CheckinDomain.new.get_user_checkins_count_in_project @member.id, @project.id
    count[:approved].should == 1
    count[:declined].should == 1
    count[:pending].should == 1
    count[:sum].should == 3
  end
end
