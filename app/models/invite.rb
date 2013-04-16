class Invite < ActiveRecord::Base
  attr_accessible :invited_user_id, :message, :project_id, :state, :token, :user_id
  validates :invited_user_id, :project_id, :user_id, :presence => true
  belongs_to :owner, :class_name => "User", :foreign_key => "user_id"
  belongs_to :project
  state_machine :initial => :pending do 
    event :approve do
      transition [:pending] => :approved
    end
    event :declin do
      transition [:pending] => :declined
    end
  end
end
