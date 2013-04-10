class Membership < ActiveRecord::Base
  attr_accessible :user_id, :project_id
  validates :user_id, :project_id, :presence => true
  belongs_to :user
  belongs_to :project
end
