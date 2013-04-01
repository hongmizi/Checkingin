class Project < ActiveRecord::Base
  attr_accessible :name

  has_many :checkins, :dependent => :destroy
end
