require File.dirname(__FILE__) + '/../spec_helper'

describe "calculating total" do
  it "should consider a discount" do
    discount  = Factory( :discount_code, :discount_rate => 0.10 )
    order     = Factory( :order, :discount_code => discount     )
    order.stub!(:item_total).and_return( 10.99 )
    order.discount_code.discount_rate.should eql (0.10)
    order.total().should eql( 10.99 - ( 10.99*0.10) )
  end

  it "should also update totals with discount and commission" do
    discount  = Factory( :discount_code, :discount_rate => 0.10 , :commission_rate => (0.05))
    order     = Factory( :order, :discount_code => discount     )
    order.stub!(:item_total).and_return( 10.99 )
    order.update_totals
    order.discount_total.should eql( 10.99*0.10 )
    order.commission_total.should eql( 10.99*0.05 )
  end
  

end