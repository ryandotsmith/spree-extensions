require File.dirname(__FILE__) + '/../spec_helper'

describe DiscountCode do

  before(:each) do
    @discount_code = DiscountCode.new
  end

  it "should be valid" do
    @discount_code.should be_valid
  end

end

describe "generating the code" do

  it "should generate something that is not to long" do
    @dc = DiscountCode.new()
    @dc.save
    @dc.code.should_not be_nil
  end

  it "should be able to set the expire date by object" do
    @dc = DiscountCode.new( :expires_on => DateTime.now + 20.days )
    @dc.expired?().should eql( false )
  end

  it "should report expired discount codes" do
    @dc = DiscountCode.new( :expires_on => DateTime.now - 2.days )
    @dc.expired?().should eql( true )    
  end


end
