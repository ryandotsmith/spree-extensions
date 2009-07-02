require File.dirname(__FILE__) + '/../spec_helper'

describe "calculating total" do
  it "should consider a discount" do
    discount  = Factory( :discount_code, :discount_rate => 0.10 )
    order     = Factory( :order, :discount_code => discount     )
    order.should_receive(:item_total).twice.and_return( 10.99 )
    order.discount_code.discount_rate.should eql(0.10)
    order.total().should eql( 10.99 - ( 10.99*0.10) )
  end

  it "should also update totals with discount and commission" do
    discount  = Factory( :discount_code, :discount_rate => 0.10 , :commission_rate => (0.05))
    order     = Factory( :order, :discount_code => discount     )
    order.should_receive(:item_total).twice.and_return( 10.99 )
    order.update_totals
    order.discount_total.should eql( 10.99*0.10 )
    order.commission_total.should eql( 10.99*0.05 )
  end
  

end

describe "calculating the item total for discounted items " do

  it "should return the item total for items that are discountable" do
    discount  = Factory( :discount_code, :discount_rate => 0.10 , :commission_rate => (0.05))
    order     = Factory( :order, :discount_code => discount     )
    order.line_items << LineItem.new
  end

  it "should not take into consideration items that are not discountable"do
  
  end

end
