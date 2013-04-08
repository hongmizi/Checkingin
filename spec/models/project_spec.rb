require 'spec_helper'

describe Project do
  before do
    @apple = Project.new(:name => "test", :description => "this is a describe ")
  end
  it "should validate presence of name" do
    @apple.name = ""
    @apple.valid?
    @apple.errors[:name].should == ["can't be blank"]
  end
  it "should validate presence of description" do
    @apple.description = ""
    @apple.valid?
    @apple.errors[:description].should == ["can't be blank"]
  end
  it "shoud work if have name and description " do
    @apple.valid?.should == true
    @apple.save.should == true
  end
end
