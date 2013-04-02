class Project < ActiveRecord::Base
  attr_accessible :name, :description

  has_many :checkins, :dependent => :destroy

  belongs_to :owner, :class_name => "User"

  has_many :memberships, :dependent => :destroy
  has_many :members, :class_name => "User", :through => :memberships
end
