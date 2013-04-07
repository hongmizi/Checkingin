require 'spec_helper'

describe Project do
  before do
    @apple = Project.new(:name => "test", :description => "this is a describe ")
  end
  it "should have name" do
    @apple.name = ""
    @apple.save.should == false
  end
  it "should have description" do
    @apple.description = ""
    @apple.save.should == false
  end
  it "shoud work if have name and description " do
    @apple.save.should == true
  end
end
