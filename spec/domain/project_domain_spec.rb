require 'spec_helper'
describe ProjectDomain do
  before do
    @manager = FactoryGirl.create(:user)
    @member = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, user_id:@manager.id)
    @project_2 = FactoryGirl.create(:project, user_id:@manager.id)
    FactoryGirl.create(:membership, user_id:@member.id, project_id:@project.id)
    FactoryGirl.create(:membership, user_id:@member.id, project_id:@project_2.id)
  end
  it "should get user joined project" do
    projects = ProjectDomain.get_user_joined_projects @member.id
    projects.count.should == 2
  end

  it "should get correct number of projects " do
    @project.destroy
    projects = ProjectDomain.get_user_joined_projects @member.id
    projects.count.should == 1
  end
end
