class Project < ActiveRecord::Base
  attr_accessible :name

  has_many :checkins, :dependent => :destroy
  has_many :users ,:through => :checkins
end
