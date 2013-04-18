class Membership < ActiveRecord::Base
  attr_accessible :user_id, :project_id
  validates :user_id, :project_id, :presence => true
  belongs_to :user
  belongs_to :project
  before_destroy :remove_user_from_project
  after_create :add_user_to_project
private
  def add_user_to_project
    @user = User.find(user_id)
    @project = Project.find(project_id)
    ProjectDomain.add_user_to_project user, @project
  end
 
  def remove_user_from_project
    @user = User.find(user_id)
    @project = Project.find(project_id)
    ProjectDomain.remove_user_from_project user, @project
    return true
  end
end
