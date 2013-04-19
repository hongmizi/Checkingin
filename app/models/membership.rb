class Membership < ActiveRecord::Base
  attr_accessible :user_id, :project_id
  validates :user_id, :project_id, :presence => true
  belongs_to :user
  belongs_to :project
  before_destroy :remove_user_from_projects
  after_create :add_user_to_projects
private
  def add_user_to_projects
    ProjectDomain.add_user_to_projects user_id, project_id
  end

  def remove_user_from_projects
    ProjectDomain.remove_user_from_projects user_id, project_id
    return true
  end
end
