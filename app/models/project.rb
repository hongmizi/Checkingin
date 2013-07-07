class Project < ActiveRecord::Base
  attr_accessible :name, :description
  validates :name, :description , :presence => true
  has_many :checkins, :dependent => :destroy

  belongs_to :owner, :class_name => "User", :foreign_key => "user_id"
  has_many :invites
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
end
