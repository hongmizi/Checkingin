class Checkin < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :user_id, :project_id, :created_at, :state, :presence => true
end
