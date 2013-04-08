class Checkin < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  attr_accessible :user_id ,:state, :project_id

  validates :user_id, :project_id, :state, :presence => true

  before_save :notify_the_manager

  state_machine :initial => :pending do
    event :approve do
      transition [:pending] => :approved
    end

    event :decline do
      transition [:pending] => :declined
    end

    before_transition :from => :pending, :to => :approved, :do => :notify_the_applier
  end

  private

  def notify_the_applier
 #   Rails.logger.info "========================================"
 #   Rails.logger.info "Hi, you have approved a request."
 #   Rails.logger.info "========================================"
  end

  def notify_the_manager
    # TODO send the email here
  end
end
