class Checkin < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  attr_accessible :user_id ,:state, :project_id, :project

  validates :user_id, :project_id, :state, :presence => true

  default_scope order('created_at DESC')

  state_machine :initial => :pending do
    event :approve do
      transition [:pending] => :approved
    end

    event :decline do
      transition [:pending] => :declined
    end
  end

  private

  def notify_the_applier
 #   Rails.logger.info "========================================"
 #   Rails.logger.info "Hi, you have approved a request."
 #   Rails.logger.info "========================================"
  end
end
