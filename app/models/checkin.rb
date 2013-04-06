class Checkin < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  attr_accessible :user_id ,:state, :project_id

  validates :user_id, :project_id, :state, :presence => true
end
