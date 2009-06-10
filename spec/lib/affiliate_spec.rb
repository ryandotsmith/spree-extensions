require File.dirname(__FILE__) + '/../spec_helper'

describe "determining if a user is an affiliate" do

  it "should report the user as an affiliate if the user has a discount code" do
    user  = Factory( :user )
    dc    = Factory( :discount_code, :user => user )
    user.is_affiliate?().should eql( true )
  end

  it "should report the user NOT to be an affiliate if the user has NO discount code" do
    user  = Factory( :user )
    user.is_affiliate?().should eql( false )    
  end

end